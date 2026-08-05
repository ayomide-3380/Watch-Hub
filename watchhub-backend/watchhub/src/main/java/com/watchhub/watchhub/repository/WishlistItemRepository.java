package com.watchhub.watchhub.repository;

import com.watchhub.watchhub.entity.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistItemRepository extends JpaRepository<WishlistItem, String> {
    List<WishlistItem> findByUserId(String userId);
    Optional<WishlistItem> findByUserIdAndWatchId(String userId, String watchId);
    void deleteByUserIdAndWatchId(String userId, String watchId);
}