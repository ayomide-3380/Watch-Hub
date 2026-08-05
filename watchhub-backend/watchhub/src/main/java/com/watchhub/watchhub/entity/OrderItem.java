package com.watchhub.watchhub.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import com.fasterxml.jackson.annotation.JsonBackReference;

import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    @JsonBackReference
    private Order order;

    @Column(name = "watch_id", nullable = false)
    private String watchId;

    @Column(nullable = false)
    private String watchTitle;

    @Column(nullable = false)
    private BigDecimal watchPrice;

    private String selectedColor;
    private String selectedStrap;

    @Column(nullable = false)
    private Integer quantity;
}