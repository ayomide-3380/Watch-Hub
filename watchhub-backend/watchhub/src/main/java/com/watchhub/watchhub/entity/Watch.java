package com.watchhub.watchhub.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "watches")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class Watch {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String brand;

    @Column(nullable = false)
    private BigDecimal price;

    private BigDecimal originalPrice;

    @Column(nullable = false)
    private BigDecimal rating;

    private Integer reviewCount = 0;

    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private String type;

    @Column(columnDefinition = "TEXT")
    private String description;

    private Integer stockCount = 0;

    private Boolean isPopular = false;
    private Boolean isFeatured = false;
    private Boolean isNewArrival = false;

    @ElementCollection
    @CollectionTable(name = "watch_images", joinColumns = @JoinColumn(name = "watch_id"))
    @Column(name = "image_url")
    private List<String> imageUrls;

    @ElementCollection
    @CollectionTable(name = "watch_specifications", joinColumns = @JoinColumn(name = "watch_id"))
    @MapKeyColumn(name = "spec_key")
    @Column(name = "spec_value")
    private Map<String, String> specifications;

    @ElementCollection
    @CollectionTable(name = "watch_colors", joinColumns = @JoinColumn(name = "watch_id"))
    @Column(name = "color")
    private List<String> availableColors;

    @ElementCollection
    @CollectionTable(name = "watch_straps", joinColumns = @JoinColumn(name = "watch_id"))
    @Column(name = "strap")
    private List<String> availableStraps;
}