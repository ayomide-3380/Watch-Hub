package com.watchhub.watchhub.repository;

import com.watchhub.watchhub.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, String> {
    List<CartItem> findByUserId(String userId);
    Optional<CartItem> findByUserIdAndWatchIdAndSelectedColorAndSelectedStrap(
            String userId, String watchId, String selectedColor, String selectedStrap
    );

    @Transactional
    void deleteByUserId(String userId);
}