package com.watchhub.watchhub.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @JsonIgnore
    @Column(nullable = false)
    private String passwordHash;

    private String phone;

    private String avatarURL;

    private Integer loyaltyPoint = 0;

    private String vipStatus = "Common";

    private Boolean isAdmin = false;

    @ElementCollection
    @CollectionTable(
            name = "addresses",
            joinColumns = @JoinColumn(name = "user_id")
    )
    @Column(name = "line")
    private List<String> shippingAddresses = new ArrayList<>();

    private String defaultAddress;
}