package com.watchhub.watchhub.controller;

import com.watchhub.watchhub.entity.Watch;
import com.watchhub.watchhub.repository.WatchRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/watches")
public class WatchController {

    private final WatchRepository watchRepository;

    public WatchController(WatchRepository watchRepository) {
        this.watchRepository = watchRepository;
    }

    @GetMapping
    public List<Watch> getAllWatches(){
        return watchRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Watch> getWatchById(@PathVariable String id){
        return watchRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Watch createWatch(@RequestBody Watch watch){
        return watchRepository.save(watch);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWatchById(@PathVariable String id){
        if (!watchRepository.existsById(id)){
            return ResponseEntity.notFound().build();
        }
        watchRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
