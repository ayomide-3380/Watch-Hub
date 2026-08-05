package com.watchhub.watchhub.controller;

import com.watchhub.watchhub.dto.CheckoutRequest;
import com.watchhub.watchhub.entity.Order;
import com.watchhub.watchhub.entity.User;
import com.watchhub.watchhub.repository.OrderRepository;
import com.watchhub.watchhub.repository.UserRepository;
import com.watchhub.watchhub.service.OrderService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;

    public OrderController(OrderService orderService, OrderRepository orderRepository, UserRepository userRepository) {
        this.orderService = orderService;
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
    }

    @PostMapping
    public ResponseEntity<?> checkout(@RequestBody CheckoutRequest request) {
        try {
            User user = userRepository.findById(request.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            Order order = orderService.checkout(request, user);
            return ResponseEntity.ok(order);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/all")
    public List<Order> getAllOrders() {
        return orderRepository.findAll(
            org.springframework.data.domain.Sort.by(
                    org.springframework.data.domain.Sort.Direction.DESC, "orderDate"
            ));
    }

    @GetMapping("/{userId}")
    public List<Order> getOrders(@PathVariable String userId) {
        return orderRepository.findByUserId(userId);
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(@PathVariable String id, @RequestBody Map<String, String> body) {
        return orderRepository.findById(id)
                .map(order -> {
                    order.setStatus(body.get("status"));
                    return ResponseEntity.ok(orderRepository.save(order));
                })
                .orElse(ResponseEntity.notFound().build());
    }
}