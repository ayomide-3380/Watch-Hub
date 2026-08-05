package com.watchhub.watchhub.repository;

import com.watchhub.watchhub.entity.Watch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WatchRepository extends JpaRepository<Watch, String>{
}
