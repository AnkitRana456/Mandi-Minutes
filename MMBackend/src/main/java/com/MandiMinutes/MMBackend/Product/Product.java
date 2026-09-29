package com.MandiMinutes.MMBackend.Product;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@NoArgsConstructor
@Builder
@AllArgsConstructor
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "price")
    private BigDecimal price;

    @Column(name = "total_stock",nullable = false)
    private Integer totalStock;

    @Column(name = "reserved_stock")
    private Integer reservedStock;

    @Column(name = "shopkeeper_id",nullable = false)
    private Long shopkeeperId;

    @Column(name = "category")
    private String category;

    private String unit;

    @Column(name = "image_url")
    private String imageUrl;


    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Long getShopkeeperId() {
        return shopkeeperId;
    }

    public void setShopkeeperId(Long shopkeeperId) {
        this.shopkeeperId = shopkeeperId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public Product(String name, BigDecimal price, String unit , Integer totalStock) {
        this.name = name;
        this.price = price;
        this.unit=unit;
        this.totalStock = totalStock;
        this.reservedStock=0;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getReservedStock() {
        return reservedStock;
    }

    public void setReservedStock(Integer reservedStock) {
        this.reservedStock = reservedStock;
    }

    public Integer getTotalStock() {
        return totalStock;
    }

    public void setTotalStock(Integer totalStock) {
        this.totalStock = totalStock;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Integer getAvailableStock() {
        return this.totalStock - this.reservedStock;
    }


}
