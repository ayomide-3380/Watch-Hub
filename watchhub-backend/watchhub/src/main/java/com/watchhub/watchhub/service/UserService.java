package com.watchhub.watchhub.service;

import com.watchhub.watchhub.entity.User;
import com.watchhub.watchhub.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final LoyaltyService loyaltyService;

    public UserService(UserRepository userRepository, LoyaltyService loyaltyService) {
        this.userRepository = userRepository;
        this.loyaltyService = loyaltyService;
    }

    public User addLoyaltyPoints(User user, int pointsEarned) {
        user.setLoyaltyPoint(user.getLoyaltyPoint() + pointsEarned);
        user.setVipStatus(loyaltyService.calculateTier(user.getIsAdmin(), user.getLoyaltyPoint()));
        return userRepository.save(user);
    }
}