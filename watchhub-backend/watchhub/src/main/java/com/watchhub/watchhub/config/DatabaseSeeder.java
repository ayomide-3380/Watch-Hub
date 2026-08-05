package com.watchhub.watchhub.config;

import com.watchhub.watchhub.entity.Watch;
import com.watchhub.watchhub.repository.WatchRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Component
public class DatabaseSeeder {

    private final WatchRepository watchRepository;

    public DatabaseSeeder(WatchRepository watchRepository) {
        this.watchRepository = watchRepository;
    }

    @PostConstruct
    public void seedDatabase() {

        if (watchRepository.count() > 0) {
            return;
        }

        // =========================
        // WATCH 1
        // =========================

        watchRepository.save(
                createWatch(
                        "Cosmograph Daytona Platinum",
                        "Rolex",
                        34500.0,
                        38000.0,
                        4.9,
                        128,
                        "Luxury",
                        "Automatic Chronograph",
                        "The benchmark for those with a passion for driving and speed. Features an ice blue dial, chestnut brown Cerachrom bezel, and platinum oyster case with self-winding Calibre 4130.",
                        4,
                        true,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Self-winding Calibre 4130",
                                "Case Material", "950 Platinum",
                                "Case Diameter", "40 mm",
                                "Water Resistance", "100m / 330 ft",
                                "Dial Color", "Ice Blue with Chestnut Bezel",
                                "Strap", "Oyster, three-piece solid links",
                                "Power Reserve", "Approximately 72 hours"
                        ),
                        List.of(
                                "Ice Blue",
                                "Slate Grey",
                                "Classic Black"
                        ),
                        List.of(
                                "Oyster Platinum",
                                "Alligator Leather"
                        )
                )
        );

        // =========================
        // WATCH 2
        // =========================

        watchRepository.save(
                createWatch(
                        "Speedmaster Professional Moonwatch",
                        "Omega",
                        7600.0,
                        8200.0,
                        4.8,
                        94,
                        "Chronograph",
                        "Manual Wind",
                        "The Legendary Moonwatch tested by NASA on all six lunar missions. Equipped with the Master Chronometer Calibre 3861 for incredible magnetic resistance and precision.",
                        8,
                        true,
                        true,
                        false,
                        List.of(
                                "https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Omega Calibre 3861",
                                "Case Material", "Stainless Steel",
                                "Case Diameter", "42 mm",
                                "Water Resistance", "50m / 167 ft",
                                "Dial Color", "Matte Black",
                                "Strap", "Steel Bracelet / NATO Nylon",
                                "Power Reserve", "50 hours"
                        ),
                        List.of(
                                "Matte Black",
                                "Silver Opalescent"
                        ),
                        List.of(
                                "Steel Bracelet",
                                "Nylon NATO",
                                "Leather Calfskin"
                        )
                )
        );

        // =========================
        // WATCH 3
        // =========================

        watchRepository.save(
                createWatch(
                        "Nautilus Self-Winding Rose Gold",
                        "Patek Philippe",
                        52000.0,
                        55000.0,
                        5.0,
                        62,
                        "Luxury",
                        "Automatic",
                        "With the iconic octagonal bezel and horizontal embossed dial, the Nautilus has personified the elegant sports watch since 1976.",
                        2,
                        true,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Calibre 26-330 S C",
                                "Case Material", "18K Rose Gold",
                                "Case Diameter", "40.5 mm",
                                "Water Resistance", "120m",
                                "Dial Color", "Rose Gold Brown Sunburst",
                                "Strap", "Rose Gold Bracelet with Fold-over Clasp",
                                "Power Reserve", "45 hours"
                        ),
                        List.of(
                                "Rose Gold",
                                "Olive Green",
                                "Classic Blue"
                        ),
                        List.of(
                                "Rose Gold Link",
                                "Chocolate Rubber"
                        )
                )
        );

        // =========================
        // WATCH 4
        // =========================

        watchRepository.save(
                createWatch(
                        "Royal Oak Offshore Diver",
                        "Audemars Piguet",
                        28900.0,
                        null,
                        4.7,
                        45,
                        "Diver",
                        "Automatic",
                        "Designed for high-impact marine exploration with Méga Tapisserie pattern, sapphire crystal glareproofed case back, and quick-change rubber strap.",
                        5,
                        false,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1619134778706-7015533a6150?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Calibre 4308",
                                "Case Material", "Stainless Steel & Ceramic",
                                "Case Diameter", "42 mm",
                                "Water Resistance", "300m / 1000 ft",
                                "Dial Color", "Khaki Green",
                                "Strap", "Textured Green Rubber",
                                "Power Reserve", "60 hours"
                        ),
                        List.of(
                                "Khaki Green",
                                "Marine Blue",
                                "Stealth Black"
                        ),
                        List.of(
                                "Green Rubber",
                                "Black Rubber"
                        )
                )
        );

        // =========================
        // WATCH 5
        // =========================

        watchRepository.save(
                createWatch(
                        "Monaco Calibre 11 Special Edition",
                        "Tag Heuer",
                        6850.0,
                        7400.0,
                        4.6,
                        81,
                        "Chronograph",
                        "Automatic",
                        "The original square-faced icon worn by Steve McQueen in Le Mans. Featuring left-hand crown, metallic blue dial, and silver sub-dials.",
                        10,
                        true,
                        false,
                        false,
                        List.of(
                                "https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Tag Heuer Calibre 11 Automatic",
                                "Case Material", "Fine-brushed Steel",
                                "Case Diameter", "39 mm",
                                "Water Resistance", "100m",
                                "Dial Color", "Metallic Blue",
                                "Strap", "Black Calfskin Leather with Racing Perforations",
                                "Power Reserve", "40 hours"
                        ),
                        List.of(
                                "Monaco Blue",
                                "Gulf Racing Stripes"
                        ),
                        List.of(
                                "Perforated Leather",
                                "Steel Link"
                        )
                )
        );

        // =========================
        // WATCH 6
        // =========================

        watchRepository.save(
                createWatch(
                        "Santos de Cartier Large Model",
                        "Cartier",
                        8100.0,
                        null,
                        4.9,
                        110,
                        "Dress",
                        "Automatic",
                        "Created in 1904 for aviator Alberto Santos-Dumont. Features QuickSwitch interchangeable strap technology and SmartLink size adjustment system.",
                        7,
                        true,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Manufacture Calibre 1847 MC",
                                "Case Material", "Steel & ADLC Bezel",
                                "Case Diameter", "39.8 mm",
                                "Water Resistance", "100m",
                                "Dial Color", "Silvered Opaline",
                                "Strap", "Interchangeable Steel & Calfskin",
                                "Power Reserve", "42 hours"
                        ),
                        List.of(
                                "Silvered Opaline",
                                "ADLC Black"
                        ),
                        List.of(
                                "Steel SmartLink",
                                "Tan Calfskin Leather"
                        )
                )
        );

        // =========================
        // WATCH 7
        // =========================

        watchRepository.save(
                createWatch(
                        "Summit 3 Smartwatch Titanium Edition",
                        "Tag Heuer",
                        2450.0,
                        2800.0,
                        4.5,
                        38,
                        "Smart",
                        "WearOS Ultra",
                        "Luxury smart companion crafted in grade 5 titanium with custom sapphire display crystal, health heart-rate sensors, and GPS navigation.",
                        15,
                        false,
                        false,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1539874754764-5a96559165b0?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Processor", "Snapdragon Wear 4100+",
                                "Case Material", "Grade 5 Titanium",
                                "Display", "1.28 AMOLED Sapphire Crystal",
                                "Water Resistance", "50m / 5 ATM",
                                "Sensors", "Heart rate, SpO2, Barometer, GPS, NFC",
                                "Battery Life", "All-Day Performance Mode"
                        ),
                        List.of(
                                "Titanium Grey",
                                "DLC Jet Black"
                        ),
                        List.of(
                                "Sport Rubber",
                                "Hand-stitched Leather"
                        )
                )
        );

        // =========================
        // WATCH 8
        // =========================

        watchRepository.save(
                createWatch(
                        "Submariner Date Kermit",
                        "Rolex",
                        14500.0,
                        15800.0,
                        4.9,
                        142,
                        "Diver",
                        "Automatic",
                        "The ultimate divers watch featuring a green Cerachrom bezel, black dial, large luminescent hour markers and Oystersteel bracelet.",
                        5,
                        true,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement", "Self-winding Calibre 3235",
                                "Case Material", "Oystersteel",
                                "Case Diameter", "41 mm",
                                "Water Resistance", "300m / 1000 ft",
                                "Dial Color", "Classic Black with Green Bezel",
                                "Strap", "Oystersteel Flat Three-piece",
                                "Power Reserve", "Approximately 70 hours"
                        ),
                        List.of(
                                "Green Bezel Black Dial",
                                "Full Jet Black"
                        ),
                        List.of(
                                "Oystersteel Bracelet",
                                "Stealth Rubber"
                        )
                )
        );

        // =========================
        // WATCH 9
        // =========================

        watchRepository.save(
                createWatch(
                        "Speedmaster Professional Moonwatch",
                        "Omega",
                        7600.0,
                        8200.0,
                        4.8,
                        94,
                        "Chronograph",
                        "Manual Wind",
                        "The legendary Moonwatch tested by NASA on all six lunar missions.",
                        8,
                        true,
                        true,
                        false,
                        List.of(
                                "https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement","Omega Calibre 3861",
                                "Case Material","Stainless Steel",
                                "Case Diameter","42 mm",
                                "Water Resistance","50m"
                        ),
                        List.of("Matte Black","Silver Opalescent"),
                        List.of("Steel Bracelet","Leather")
                )
        );

        // =========================
        // WATCH 10
        // =========================

        watchRepository.save(
                createWatch(
                        "Nautilus Self-Winding Rose Gold",
                        "Patek Philippe",
                        52000.0,
                        55000.0,
                        5.0,
                        62,
                        "Luxury",
                        "Automatic",
                        "Iconic luxury sports watch with octagonal bezel.",
                        2,
                        true,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement","Calibre 26-330 S C",
                                "Case Material","18K Rose Gold",
                                "Case Diameter","40.5 mm",
                                "Water Resistance","120m"
                        ),
                        List.of("Rose Gold","Olive Green"),
                        List.of("Rose Gold Bracelet","Rubber")
                )
        );

        // =========================
        // WATCH 11
        // =========================

        watchRepository.save(
                createWatch(
                        "Royal Oak Offshore Diver",
                        "Audemars Piguet",
                        28900.0,
                        null,
                        4.7,
                        45,
                        "Diver",
                        "Automatic",
                        "Designed for high-impact marine exploration.",
                        5,
                        false,
                        true,
                        true,
                        List.of(
                                "https://images.unsplash.com/photo-1619134778706-7015533a6150?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement","Calibre 4308",
                                "Case Material","Steel",
                                "Case Diameter","42 mm",
                                "Water Resistance","300m"
                        ),
                        List.of("Khaki Green","Black"),
                        List.of("Green Rubber","Black Rubber")
                )
        );

        // =========================
        // WATCH 12
        // =========================

        watchRepository.save(
                createWatch(
                        "Monaco Calibre 11 Special Edition",
                        "Tag Heuer",
                        6850.0,
                        7400.0,
                        4.6,
                        81,
                        "Chronograph",
                        "Automatic",
                        "The iconic square racing watch.",
                        10,
                        true,
                        false,
                        false,
                        List.of(
                                "https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800",
                                "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800"
                        ),
                        Map.of(
                                "Movement","Calibre 11",
                                "Case Material","Steel",
                                "Case Diameter","39 mm",
                                "Water Resistance","100m"
                        ),
                        List.of("Blue"),
                        List.of("Leather","Steel")
                )
        );

    }

    private Watch createWatch(
            String title,
            String brand,
            double price,
            Double originalPrice,
            double rating,
            int reviewCount,
            String category,
            String type,
            String description,
            int stockCount,
            boolean isPopular,
            boolean isFeatured,
            boolean isNewArrival,
            List<String> imageUrls,
            Map<String, String> specifications,
            List<String> colors,
            List<String> straps
    ) {

        Watch watch = new Watch();

        watch.setTitle(title);
        watch.setBrand(brand);
        watch.setPrice(BigDecimal.valueOf(price));

        if (originalPrice != null) {
            watch.setOriginalPrice(BigDecimal.valueOf(originalPrice));
        }

        watch.setRating(BigDecimal.valueOf(rating));
        watch.setReviewCount(reviewCount);
        watch.setCategory(category);
        watch.setType(type);
        watch.setDescription(description);
        watch.setStockCount(stockCount);

        watch.setIsPopular(isPopular);
        watch.setIsFeatured(isFeatured);
        watch.setIsNewArrival(isNewArrival);

        watch.setImageUrls(imageUrls);
        watch.setSpecifications(specifications);
        watch.setAvailableColors(colors);
        watch.setAvailableStraps(straps);

        return watch;
    }
}