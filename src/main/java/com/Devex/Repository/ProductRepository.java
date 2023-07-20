package com.Devex.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.stereotype.Repository;

import com.Devex.Entity.Product;

@EnableJpaRepositories
@Repository("productRepository")
public interface ProductRepository extends JpaRepository<Product, String>{

	@Query("SELECT DISTINCT p FROM Product p " +
	           "JOIN FETCH p.sellerProduct s " +
	           "WHERE s.username = ?1")
	    List<Product> findProductBySellerUsername(String sellerUsername);
	
}