package com.watchhub.watchhub.service;

import com.watchhub.watchhub.dto.CheckoutRequest;
import com.watchhub.watchhub.entity.*;
import com.watchhub.watchhub.repository.CartItemRepository;
import com.watchhub.watchhub.repository.OrderRepository;
import com.watchhub.watchhub.repository.WatchRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class OrderService {

    private final CartItemRepository cartItemRepository;
    private final WatchRepository watchRepository;
    private final OrderRepository orderRepository;
    private final UserService userService;

    public OrderService(CartItemRepository cartItemRepository, WatchRepository watchRepository,
                        OrderRepository orderRepository, UserService userService) {
        this.cartItemRepository = cartItemRepository;
        this.watchRepository = watchRepository;
        this.orderRepository = orderRepository;
        this.userService = userService;
    }

    public Order checkout(CheckoutRequest request, User user) {
        List<CartItem> cartItems = cartItemRepository.findByUserId(request.getUserId());
        if (cartItems.isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Order order = new Order();
        order.setUserId(request.getUserId());
        order.setShippingAddress(request.getShippingAddress());
        order.setPaymentMethod(request.getPaymentMethod());

        BigDecimal subtotal = BigDecimal.ZERO;

        for (CartItem cartItem : cartItems) {
            Watch watch = watchRepository.findById(cartItem.getWatchId())
                    .orElseThrow(() -> new RuntimeException("Watch not found: " + cartItem.getWatchId()));

            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setWatchId(watch.getId());
            item.setWatchTitle(watch.getTitle());
            item.setWatchPrice(watch.getPrice());
            item.setSelectedColor(cartItem.getSelectedColor());
            item.setSelectedStrap(cartItem.getSelectedStrap());
            item.setQuantity(cartItem.getQuantity());

            order.getItems().add(item);

            subtotal = subtotal.add(watch.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
        }

        BigDecimal discountAmount = request.getDiscountAmount() != null
                ? request.getDiscountAmount() : BigDecimal.ZERO;

        // Keep these in sync with CartProvider's calculation on the frontend
        BigDecimal tax = subtotal.subtract(discountAmount).multiply(BigDecimal.valueOf(0.08)); // 8% tax
        BigDecimal shippingFee = subtotal.compareTo(BigDecimal.valueOf(10000)) > 0
                ? BigDecimal.ZERO : BigDecimal.valueOf(150); // free shipping over $10,000
        BigDecimal total = subtotal.subtract(discountAmount).add(tax).add(shippingFee);

        order.setSubtotal(subtotal);
        order.setTax(tax);
        order.setShippingFee(shippingFee);
        order.setDiscount(discountAmount);
        order.setTotalAmount(total);

        Order savedOrder = orderRepository.save(order);

        // award loyalty points — e.g. 1 point per 1000 spent — and clear the cart
        int pointsEarned = subtotal.divide(BigDecimal.valueOf(1000)).intValue();
        userService.addLoyaltyPoints(user, pointsEarned);
        cartItemRepository.deleteByUserId(request.getUserId());

        return savedOrder;
    }
}