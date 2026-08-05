package com.watchhub.watchhub.controller;

import com.watchhub.watchhub.entity.WishlistItem;
import com.watchhub.watchhub.repository.WishlistItemRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wishlist")
public class WishlistController {

    private final WishlistItemRepository wishlistItemRepository;

    public WishlistController(WishlistItemRepository wishlistItemRepository) {
        this.wishlistItemRepository = wishlistItemRepository;
    }

    @GetMapping("/{userId}")
    public List<WishlistItem> getWishlist(@PathVariable String userId) {
        return wishlistItemRepository.findByUserId(userId);
    }

    @PostMapping
    public ResponseEntity<WishlistItem> addToWishlist(@RequestBody WishlistItem request) {
        boolean alreadyExists = wishlistItemRepository
                .findByUserIdAndWatchId(request.getUserId(), request.getWatchId())
                .isPresent();

        if (alreadyExists) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(wishlistItemRepository.save(request));
    }

    @DeleteMapping("/{userId}/{watchId}")
    public ResponseEntity<Void> removeFromWishlist(@PathVariable String userId, @PathVariable String watchId) {
        wishlistItemRepository.deleteByUserIdAndWatchId(userId, watchId);
        return ResponseEntity.noContent().build();
    }
}