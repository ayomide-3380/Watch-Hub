package com.watchhub.watchhub.service;

import org.springframework.stereotype.Service;

@Service
public class LoyaltyService {

    public String calculateTier (boolean isAdmin, int points) {
        if (isAdmin) return "Admin";
        if (points > 1500) return "Supreme Collector";
        if (points >= 1000) return "Platinum";
        if (points >= 700) return "Diamond";
        if (points >= 500) return "Gold";
        if (points >= 300) return "Silver";
        if (points >= 100) return "Bronze";
        return "Common";
    }
}
