package com.watchhub.watchhub.service;

import com.watchhub.watchhub.dto.LoginRequest;
import com.watchhub.watchhub.dto.RegisterRequest;
import com.watchhub.watchhub.entity.User;
import com.watchhub.watchhub.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final LoyaltyService loyaltyService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, LoyaltyService loyaltyService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.loyaltyService = loyaltyService;
    }

    public User register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already registered");
        }
        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        return userRepository.save(user);
    }

    public User login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Invalid email or password");
        }
        // Keep vipStatus in sync with isAdmin/loyaltyPoint on every login,
        // in case either changed outside the normal checkout flow (e.g. an
        // admin flag set directly in the database).
        String correctTier = loyaltyService.calculateTier(user.getIsAdmin(), user.getLoyaltyPoint());
        if (!correctTier.equals(user.getVipStatus())) {
            user.setVipStatus(correctTier);
            user = userRepository.save(user);
        }
        return user;
    }
}