package com.watchhub.watchhub.controller;

import com.watchhub.watchhub.dto.UpdateProfileRequest;
import com.watchhub.watchhub.entity.User;
import com.watchhub.watchhub.repository.UserRepository;
import com.watchhub.watchhub.service.LoyaltyService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;
    private final LoyaltyService loyaltyService;

    public UserController(UserRepository userRepository, LoyaltyService loyaltyService) {
        this.userRepository = userRepository;
        this.loyaltyService = loyaltyService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable String id) {
        return userRepository.findById(id)
                .map(user -> {
                    String correctTier = loyaltyService.calculateTier(user.getIsAdmin(), user.getLoyaltyPoint());
                    if (!correctTier.equals(user.getVipStatus())) {
                        user.setVipStatus(correctTier);
                        user = userRepository.save(user);
                    }
                    return ResponseEntity.ok(user);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}")
    public ResponseEntity<User> updateProfile(@PathVariable String id, @RequestBody UpdateProfileRequest request) {
        return userRepository.findById(id)
                .map(user -> {
                    if (request.getName() != null) user.setName(request.getName());
                    if (request.getPhone() != null) user.setPhone(request.getPhone());
                    if (request.getAvatarUrl() != null) user.setAvatarURL(request.getAvatarUrl());
                    if (request.getDefaultAddress() != null) user.setDefaultAddress(request.getDefaultAddress());
                    return ResponseEntity.ok(userRepository.save(user));
                })
                .orElse(ResponseEntity.notFound().build());
    }
}