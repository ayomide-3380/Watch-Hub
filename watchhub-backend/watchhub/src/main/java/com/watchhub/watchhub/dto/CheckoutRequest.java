package com.watchhub.watchhub.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class CheckoutRequest {
    private String userId;
    private String shippingAddress;
    private String paymentMethod;
    private BigDecimal discountAmount = BigDecimal.ZERO;
}