package com.watchhub.watchhub.controller;

import com.watchhub.watchhub.entity.CartItem;
import com.watchhub.watchhub.repository.CartItemRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartItemRepository cartItemRepository;

    public CartController(CartItemRepository cartItemRepository) {
        this.cartItemRepository = cartItemRepository;
    }

    @GetMapping("/{userId}")
    public List<CartItem> getCart(@PathVariable String userId) {
        return cartItemRepository.findByUserId(userId);
    }

    @PostMapping
    public CartItem addToCart(@RequestBody CartItem request) {
        Optional<CartItem> existing = cartItemRepository
                .findByUserIdAndWatchIdAndSelectedColorAndSelectedStrap(
                        request.getUserId(), request.getWatchId(),
                        request.getSelectedColor(), request.getSelectedStrap()
                );

        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            return cartItemRepository.save(item);
        }
        return cartItemRepository.save(request);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<CartItem> updateQuantity(@PathVariable String id, @RequestBody CartItem request) {
        return cartItemRepository.findById(id)
                .map(item -> {
                    item.setQuantity(request.getQuantity());
                    return ResponseEntity.ok(cartItemRepository.save(item));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> removeFromCart(@PathVariable String id) {
        if (!cartItemRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        cartItemRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/clear/{userId}")
    public ResponseEntity<Void> clearCart(@PathVariable String userId) {
        cartItemRepository.deleteByUserId(userId);
        return ResponseEntity.noContent().build();
    }
}