# Cloud Kitchen API Documentation

## Table of Contents
1. [Base Configuration](#base-configuration)
2. [Authentication](#authentication)
3. [User Endpoints](#user-endpoints)
4. [Food Endpoints](#food-endpoints)
5. [Cart Endpoints](#cart-endpoints)
6. [Order Endpoints](#order-endpoints)
7. [Promo Code Endpoints](#promo-code-endpoints)
8. [Category Endpoints](#category-endpoints)
9. [Admin Endpoints](#admin-endpoints)
10. [Rider Endpoints](#rider-endpoints)
11. [Daily Special Endpoints](#daily-special-endpoints)
12. [Post (Blog) Endpoints](#post-blog-endpoints)
13. [Inquiry Endpoints](#inquiry-endpoints)
14. [Tag Endpoints](#tag-endpoints)
15. [Data Models](#data-models)

---

## Base Configuration

### Base URL
```
Production: https://tastykhaja.com/api
Development: http://localhost:5001/api
```

### Headers
All requests should include:
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json"
}
```

### CORS Configuration
Allowed Origins:
- http://localhost:3000
- https://tastykhaja.com
- https://www.tastykhaja.com

### Cookie Configuration
- Authentication tokens are stored in HTTP-only cookies
- Cookie Name: `token` (for users), `adminToken` (for admins)
- Secure: Only sent over HTTPS in production
- SameSite: Strict
- Max Age: 6 hours (21,600,000 ms)

---

## Authentication

### Authentication Flow

#### JWT Token Details
- **Secret**: `JWT_SECRET` environment variable
- **Algorithm**: HS256
- **Expiration**: 6 hours
- **Payload for Users**: `{ userId: ObjectId, role: 'user' | 'rider' }`
- **Payload for Admins**: `{ adminId: ObjectId, role: 'admin' }`

#### Protected Routes
Routes requiring `protect` middleware need a valid JWT token in cookies.

```
✓ Token automatically sent with credentials: true
✓ Invalid tokens return 401 Unauthorized
✓ Expired tokens return 401 Session expired
```

#### Admin Protected Routes
Routes requiring `adminProtect` middleware need admin JWT token.

---

## User Endpoints

### 1. Register User
**Endpoint:** `POST /users/register`  
**Auth:** Public

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePassword123!",
  "phone": "+977981234567"
}
```

**Response (201 Created):**
```json
{
  "message": "Registration successful",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "fullName": "John Doe",
    "email": "john@example.com",
    "photo": null,
    "orderCount": 0
  }
}
```

**Error Responses:**
```json
{
  "message": "All fields are required"
}
```
```json
{
  "message": "Email already registered"
}
```

---

### 2. Login User
**Endpoint:** `POST /users/login`  
**Auth:** Public

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "SecurePassword123!"
}
```

**Response (200 OK):**
```json
{
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "fullName": "John Doe",
    "email": "john@example.com",
    "role": "user",
    "photo": "https://res.cloudinary.com/...",
    "orderCount": 5
  }
}
```

**Error Responses:**
```json
{
  "message": "Email and password are required"
}
```
```json
{
  "message": "Invalid credentials"
}
```
```json
{
  "message": "Account is blocked"
}
```
```json
{
  "message": "Please log in using your social account"
}
```

---

### 3. Google Login
**Endpoint:** `POST /users/google`  
**Auth:** Public

**Request Body:**
```json
{
  "code": "4/0AX4XfWh...", // Authorization code from Google
  "redirectUri": "http://localhost:3000/auth/google/callback"
}
```

**Response (200 OK):**
```json
{
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "fullName": "John Doe",
    "email": "john@example.com",
    "googleId": "118145818841234567890",
    "authProvider": "google",
    "isVerified": true,
    "photo": "https://lh3.googleusercontent.com/...",
    "orderCount": 0
  }
}
```

**Error Responses:**
```json
{
  "message": "Google login failed",
  "error": "Error details"
}
```

---

### 4. Logout User
**Endpoint:** `POST /users/logout`  
**Auth:** Public

**Request Body:** Empty

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User logged out successfully"
}
```

---

### 5. Get User Profile
**Endpoint:** `GET /users/profile`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "fullName": "John Doe",
    "email": "john@example.com",
    "phone": "+977981234567",
    "photo": "https://res.cloudinary.com/...",
    "deliveryAddress": {
      "addressLine": "123 Main Street",
      "city": "Pokhara",
      "state": "Gandaki",
      "zipCode": "33700"
    },
    "role": "user",
    "totalPoints": 250,
    "createdAt": "2024-01-15T10:30:00.000Z",
    "updatedAt": "2024-01-20T15:45:00.000Z"
  }
}
```

---

### 6. Update User Profile
**Endpoint:** `PUT /users/profile`  
**Auth:** Required (User)  
**Multipart:** Form Data (for photo upload)

**Request Body (Form Data):**
```
fullName: "John Doe Updated"
email: "john.new@example.com"
phone: "+977981234567"
deliveryAddress[addressLine]: "456 New Street"
deliveryAddress[city]: "Pokhara"
deliveryAddress[state]: "Gandaki"
deliveryAddress[zipCode]: "33700"
photo: <File> (optional)
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "fullName": "John Doe Updated",
    "email": "john.new@example.com",
    "phone": "+977981234567",
    "photo": "https://res.cloudinary.com/...",
    "deliveryAddress": {
      "addressLine": "456 New Street",
      "city": "Pokhara",
      "state": "Gandaki",
      "zipCode": "33700"
    }
  }
}
```

---

### 7. Change Password
**Endpoint:** `PUT /users/change-password`  
**Auth:** Required (User)

**Request Body:**
```json
{
  "currentPassword": "OldPassword123!",
  "newPassword": "NewPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

**Error Response:**
```json
{
  "message": "Current password incorrect"
}
```

---

### 8. Forgot Password
**Endpoint:** `POST /users/forgot-password`  
**Auth:** Public

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset email sent to john@example.com"
}
```

---

### 9. Reset Password with Token
**Endpoint:** `POST /users/reset-password`  
**Auth:** Public

**Request Body:**
```json
{
  "resetToken": "token_received_in_email",
  "newPassword": "NewPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

---

### 10. Delete Account
**Endpoint:** `DELETE /users/account`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Account deleted successfully"
}
```

---

## Food Endpoints

### 1. Get Available Food
**Endpoint:** `GET /foods/available`  
**Auth:** Public

**Query Parameters:**
- None (returns all available food with available variants)

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "name": "Chicken Biryani",
    "slug": "chicken-biryani",
    "description": "Fragrant rice with spiced chicken",
    "image": {
      "url": "https://res.cloudinary.com/...",
      "imageId": "foods/chicken_biryani_abc123"
    },
    "category": {
      "_id": "507f1f77bcf86cd799439012",
      "name": "Biryani"
    },
    "isAvailable": true,
    "orderCount": 42,
    "variants": [
      {
        "_id": "607f1f77bcf86cd799439013",
        "label": "Half",
        "price": 350,
        "discountedPrice": 300,
        "points": 50,
        "isAvailable": true
      },
      {
        "_id": "607f1f77bcf86cd799439014",
        "label": "Full",
        "price": 600,
        "discountedPrice": 500,
        "points": 100,
        "isAvailable": true
      }
    ],
    "createdAt": "2024-01-10T08:00:00.000Z",
    "updatedAt": "2024-01-20T15:45:00.000Z"
  }
]
```

---

### 2. Get Popular Food
**Endpoint:** `GET /foods/popular`  
**Auth:** Public

**Response (200 OK):**
Returns top 10 most ordered foods (same structure as available food)

---

### 3. Get Single Food
**Endpoint:** `GET /foods/:id`  
**Auth:** Public

**Response (200 OK):** (Same as food object structure)

**Error Response:**
```json
{
  "message": "Food not found"
}
```

---

### 4. Get All Food (Admin)
**Endpoint:** `GET /foods`  
**Auth:** Required (Admin)

**Response (200 OK):** Array of all food items

---

### 5. Create Food (Admin)
**Endpoint:** `POST /foods`  
**Auth:** Required (Admin)  
**Multipart:** Form Data

**Request Body (Form Data):**
```
name: "Mutton Biryani"
description: "Premium mutton biryani"
category: "507f1f77bcf86cd799439012"
isAvailable: "true"
image: <File> (required)
variants: '[
  {
    "label": "Half",
    "price": 450,
    "discountedPrice": 400,
    "points": 75,
    "isAvailable": true
  },
  {
    "label": "Full",
    "price": 800,
    "discountedPrice": 700,
    "points": 150,
    "isAvailable": true
  }
]'
```

**Response (201 Created):**
```json
{
  "_id": "507f1f77bcf86cd799439015",
  "name": "Mutton Biryani",
  "slug": "mutton-biryani",
  "description": "Premium mutton biryani",
  "image": {
    "url": "https://res.cloudinary.com/...",
    "imageId": "foods/mutton_biryani_xyz789"
  },
  "category": "507f1f77bcf86cd799439012",
  "isAvailable": true,
  "orderCount": 0,
  "variants": [
    {
      "_id": "607f1f77bcf86cd799439016",
      "label": "Half",
      "price": 450,
      "discountedPrice": 400,
      "points": 75,
      "isAvailable": true
    },
    {
      "_id": "607f1f77bcf86cd799439017",
      "label": "Full",
      "price": 800,
      "discountedPrice": 700,
      "points": 150,
      "isAvailable": true
    }
  ]
}
```

**Error Response:**
```json
{
  "message": "Image is required"
}
```

---

### 6. Update Food (Admin)
**Endpoint:** `PUT /foods/:id`  
**Auth:** Required (Admin)  
**Multipart:** Form Data

**Request Body:** Same as Create Food (all fields optional)

**Response (200 OK):** Updated food object

---

### 7. Delete Food (Admin)
**Endpoint:** `DELETE /foods/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Food deleted successfully"
}
```

---

## Cart Endpoints

### 1. Get Cart
**Endpoint:** `GET /cart`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "user": "507f1f77bcf86cd799439001",
    "items": [
      {
        "_id": "607f1f77bcf86cd799439012",
        "foodItem": {
          "_id": "507f1f77bcf86cd799439011",
          "name": "Chicken Biryani",
          "image": {
            "url": "https://res.cloudinary.com/...",
            "imageId": "foods/chicken_biryani_abc123"
          },
          "variants": [
            {
              "_id": "607f1f77bcf86cd799439013",
              "label": "Half",
              "price": 350,
              "discountedPrice": 300,
              "points": 50,
              "isAvailable": true
            }
          ]
        },
        "variantId": "607f1f77bcf86cd799439013",
        "quantity": 2
      }
    ],
    "createdAt": "2024-01-15T10:30:00.000Z",
    "updatedAt": "2024-01-20T15:45:00.000Z"
  }
}
```

---

### 2. Add to Cart
**Endpoint:** `POST /cart`  
**Auth:** Required (User)

**Request Body:**
```json
{
  "foodItemId": "507f1f77bcf86cd799439011",
  "variantId": "607f1f77bcf86cd799439013",
  "quantity": 2
}
```

**Response (200 OK):** Updated cart object (same structure as Get Cart)

---

### 3. Update Cart Item
**Endpoint:** `PUT /cart/:itemId`  
**Auth:** Required (User)

**Request Body:**
```json
{
  "quantity": 3
}
```

**Response (200 OK):** Updated cart object

**Note:** Set quantity to 0 or negative to remove item

---

### 4. Remove from Cart
**Endpoint:** `DELETE /cart/:itemId`  
**Auth:** Required (User)

**Response (200 OK):** Updated cart object

---

### 5. Clear Cart
**Endpoint:** `DELETE /cart`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "user": "507f1f77bcf86cd799439001",
    "items": []
  }
}
```

---

## Order Endpoints

### 1. Create Order
**Endpoint:** `POST /orders`  
**Auth:** Required (User)

**Request Body:**
```json
{
  "deliveryAddress": {
    "addressLine": "123 Main Street",
    "city": "Pokhara",
    "phone": "+977981234567"
  },
  "userLocation": {
    "lat": 28.193823,
    "lng": 83.977514
  },
  "promoCode": "SAVE10",
  "freeItemIds": [],
  "pointsToRedeem": 100,
  "requestedDeliveryTime": "2024-01-21T18:00:00.000Z",
  "paymentMethod": "COD"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "user": "507f1f77bcf86cd799439001",
    "orderId": "ORD-1705856400000",
    "items": [
      {
        "_id": "607f1f77bcf86cd799439021",
        "foodItem": "507f1f77bcf86cd799439011",
        "name": "Chicken Biryani (Half)",
        "quantity": 2,
        "priceAtPurchase": 300,
        "isFree": false
      }
    ],
    "subTotal": 600,
    "discountAmount": 60,
    "deliveryCharge": 50,
    "totalAmount": 590,
    "pointsEarned": 100,
    "pointsRedeemed": 100,
    "status": "Pending",
    "promoCode": "SAVE10",
    "deliveryAddress": {
      "addressLine": "123 Main Street",
      "city": "Pokhara",
      "phone": "+977981234567"
    },
    "userLocation": {
      "lat": 28.193823,
      "lng": 83.977514
    },
    "distance": 2.5,
    "requestedDeliveryTime": "2024-01-21T18:00:00.000Z",
    "paymentMethod": "COD",
    "paymentStatus": "Pending",
    "createdAt": "2024-01-21T17:00:00.000Z"
  }
}
```

**Error Responses:**
```json
{
  "success": false,
  "message": "Location is required to calculate delivery distance."
}
```
```json
{
  "success": false,
  "message": "Delivery time must be at least 30 minutes from now."
}
```
```json
{
  "success": false,
  "message": "Cart is empty"
}
```
```json
{
  "success": false,
  "message": "Insufficient points."
}
```

---

### 2. Get User Orders
**Endpoint:** `GET /orders`  
**Auth:** Required (User)

**Query Parameters:**
- `status`: Filter by status (Pending, Preparing, Ready for Delivery, Out for Delivery, Delivered, Cancelled)
- `skip`: Pagination (default: 0)
- `limit`: Items per page (default: 10)

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439020",
    "orderId": "ORD-1705856400000",
    "items": [...],
    "totalAmount": 590,
    "status": "Preparing",
    "createdAt": "2024-01-21T17:00:00.000Z"
  }
]
```

---

### 3. Get Order Details
**Endpoint:** `GET /orders/:id`  
**Auth:** Required (User or Admin)

**Response (200 OK):** Complete order object

---

### 4. Get User Stats
**Endpoint:** `GET /orders/stats`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "totalOrders": 15,
    "totalSpent": 12500,
    "averageOrderValue": 833.33,
    "totalPoints": 250,
    "cancelledOrders": 1,
    "lastOrderDate": "2024-01-20T15:45:00.000Z"
  }
}
```

---

### 5. Cancel Order
**Endpoint:** `PUT /orders/:id/cancel`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Order cancelled successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "status": "Cancelled"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Cannot cancel delivered/cancelled orders"
}
```

---

### 6. Get All Orders (Admin)
**Endpoint:** `GET /orders/admin`  
**Auth:** Required (Admin)

**Query Parameters:**
- `status`: Filter by status
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):** Array of all orders

---

### 7. Update Order Status (Admin)
**Endpoint:** `PUT /orders/:id/status`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "status": "Preparing"
}
```

**Valid Status Values:** Pending, Preparing, Ready for Delivery, Out for Delivery, Delivered, Cancelled

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Order status updated",
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "status": "Preparing"
  }
}
```

---

### 8. Get Admin Stats
**Endpoint:** `GET /orders/admin/stats`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "totalOrders": 250,
    "totalRevenue": 125000,
    "averageOrderValue": 500,
    "todayOrders": 15,
    "todayRevenue": 7500,
    "weeklyRevenue": 45000,
    "monthlyRevenue": 180000,
    "pendingOrders": 5,
    "preparingOrders": 3,
    "readyOrders": 2,
    "outForDeliveryOrders": 1
  }
}
```

---

### 9. Get Sales Report (Admin)
**Endpoint:** `GET /orders/admin/sales`  
**Auth:** Required (Admin)

**Query Parameters:**
- `startDate`: ISO date string
- `endDate`: ISO date string
- `groupBy`: "day" | "week" | "month"

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "date": "2024-01-21",
      "totalOrders": 12,
      "totalRevenue": 6000,
      "itemsSold": 45
    }
  ]
}
```

---

## Promo Code Endpoints

### 1. Validate Promo Code
**Endpoint:** `POST /promo-codes/validate`  
**Auth:** Required (User)

**Request Body:**
```json
{
  "code": "SAVE10",
  "subtotal": 1000
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "code": "SAVE10",
    "description": "Save 10% on all orders",
    "benefitTypes": ["percentage"],
    "discountAmount": 100,
    "discountValue": 10,
    "freeItems": []
  }
}
```

**Error Responses:**
```json
{
  "success": false,
  "message": "Invalid promo code"
}
```
```json
{
  "success": false,
  "message": "Promo code has expired"
}
```
```json
{
  "success": false,
  "message": "Minimum order amount of Rs. 500 required"
}
```
```json
{
  "success": false,
  "message": "You have already used this promo code"
}
```

---

### 2. Get Promo Usage Info
**Endpoint:** `GET /promo-codes/usage/:code`  
**Auth:** Required (User)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "code": "SAVE10",
    "hasUsed": false,
    "usedAt": null,
    "remainingUses": null,
    "expiryDate": "2024-02-28T23:59:59.000Z"
  }
}
```

---

### 3. Get All Promo Codes (Admin)
**Endpoint:** `GET /promo-codes`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439030",
    "code": "SAVE10",
    "description": "Save 10% on all orders",
    "benefitTypes": ["percentage"],
    "discountValue": 10,
    "freeItemIds": [],
    "minOrderAmount": 500,
    "expiryDate": "2024-02-28T23:59:59.000Z",
    "isActive": true,
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
]
```

---

### 4. Create Promo Code (Admin)
**Endpoint:** `POST /promo-codes`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "code": "NEWYEAR50",
  "description": "New Year special - Flat 50 Rs discount",
  "benefitTypes": ["fixed_amount"],
  "discountValue": 50,
  "freeItemIds": [],
  "minOrderAmount": 1000,
  "expiryDate": "2024-02-28T23:59:59.000Z",
  "isActive": true
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439031",
    "code": "NEWYEAR50",
    "description": "New Year special - Flat 50 Rs discount",
    "benefitTypes": ["fixed_amount"],
    "discountValue": 50,
    "freeItemIds": [],
    "minOrderAmount": 1000,
    "expiryDate": "2024-02-28T23:59:59.000Z",
    "isActive": true
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Code already exists"
}
```

---

### 5. Update Promo Code (Admin)
**Endpoint:** `PUT /promo-codes/:id`  
**Auth:** Required (Admin)

**Request Body:** Same as Create (all fields optional)

**Response (200 OK):** Updated promo object

---

### 6. Toggle Promo Status (Admin)
**Endpoint:** `PATCH /promo-codes/:id`  
**Auth:** Required (Admin)

**Request Body:** Empty

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439031",
    "code": "NEWYEAR50",
    "isActive": false
  }
}
```

---

### 7. Delete Promo Code (Admin)
**Endpoint:** `DELETE /promo-codes/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Promo code deleted"
}
```

---

## Category Endpoints

### 1. Get All Categories
**Endpoint:** `GET /categories`  
**Auth:** Public

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439012",
      "name": "Biryani",
      "slug": "biryani",
      "description": "Traditional rice dishes",
      "seoTitle": "Best Biryani",
      "seoDescription": "Order the best biryani online",
      "parent": null,
      "createdAt": "2024-01-10T08:00:00.000Z"
    }
  ]
}
```

---

### 2. Get Category by ID
**Endpoint:** `GET /categories/:id`  
**Auth:** Public

**Response (200 OK):** Single category object

**Error Response:**
```json
{
  "success": false,
  "message": "Category not found"
}
```

---

### 3. Create Category (Admin)
**Endpoint:** `POST /categories`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "name": "Curries",
  "description": "Authentic curries",
  "seoTitle": "Best Curries",
  "seoDescription": "Order authentic curries",
  "parent": null
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439013",
    "name": "Curries",
    "slug": "curries",
    "description": "Authentic curries",
    "seoTitle": "Best Curries",
    "seoDescription": "Order authentic curries",
    "parent": null
  }
}
```

**Error Response:**
```json
{
  "error": "Category with this name already exists"
}
```

---

### 4. Update Category (Admin)
**Endpoint:** `PUT /categories/:id`  
**Auth:** Required (Admin)

**Request Body:** Same as Create (all fields optional)

**Response (200 OK):** Updated category object

---

### 5. Delete Category (Admin)
**Endpoint:** `DELETE /categories/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Category deleted"
}
```

---

## Food Category Endpoints

### 1. Get All Food Categories
**Endpoint:** `GET /food-categories`  
**Auth:** Public

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439012",
    "name": "Biryani",
    "slug": "biryani",
    "description": "Traditional rice dishes",
    "isActive": true,
    "createdAt": "2024-01-10T08:00:00.000Z"
  }
]
```

---

### 2. Create Food Category (Admin)
**Endpoint:** `POST /food-categories`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "name": "Desserts",
  "description": "Sweet treats"
}
```

**Response (201 Created):** Food category object

---

### 3. Update Food Category (Admin)
**Endpoint:** `PUT /food-categories/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Updated food category

---

### 4. Delete Food Category (Admin)
**Endpoint:** `DELETE /food-categories/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Food category deleted"
}
```

---

## Admin Endpoints

### 1. Admin Register
**Endpoint:** `POST /admin-users/register`  
**Auth:** Public (First admin registration)

**Request Body:**
```json
{
  "name": "Admin User",
  "email": "admin@example.com",
  "password": "AdminPassword123!"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Admin created successfully",
  "admin": {
    "id": "507f1f77bcf86cd799439040",
    "name": "Admin User",
    "email": "admin@example.com"
  }
}
```

**Error Response:**
```json
{
  "message": "Admin email already exists"
}
```

---

### 2. Admin Login
**Endpoint:** `POST /admin-users/login`  
**Auth:** Public

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "AdminPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "admin": {
    "id": "507f1f77bcf86cd799439040",
    "name": "Admin User",
    "email": "admin@example.com"
  }
}
```

**Error Response:**
```json
{
  "message": "Invalid admin credentials"
}
```

---

### 3. Admin Logout
**Endpoint:** `POST /admin-users/logout`  
**Auth:** Public

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Admin logged out successfully"
}
```

---

### 4. Get Admin Profile
**Endpoint:** `GET /admin-users/profile`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "admin": {
    "_id": "507f1f77bcf86cd799439040",
    "name": "Admin User",
    "email": "admin@example.com"
  }
}
```

---

### 5. Change Admin Password
**Endpoint:** `PUT /admin-users/change-password`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "currentPassword": "OldPassword123!",
  "newPassword": "NewPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Admin password updated"
}
```

---

### 6. Admin Forgot Password
**Endpoint:** `POST /admin-users/forgot-password`  
**Auth:** Public

**Request Body:**
```json
{
  "email": "admin@example.com"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset email sent"
}
```

---

### 7. Admin Reset Password
**Endpoint:** `POST /admin-users/reset-password`  
**Auth:** Public

**Request Body:**
```json
{
  "resetToken": "token_from_email",
  "newPassword": "NewPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

---

### 8. Get Dashboard Stats
**Endpoint:** `GET /admin-users/dashboard-stats`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "stats": {
    "totalRevenue": 125000,
    "totalOrders": 250,
    "totalUsers": 150,
    "totalRiders": 10,
    "averageOrderValue": 500,
    "todayOrders": 15,
    "todayRevenue": 7500,
    "weeklyRevenue": 45000,
    "monthlyRevenue": 180000,
    "topFoods": [
      {
        "_id": "507f1f77bcf86cd799439011",
        "name": "Chicken Biryani",
        "orderCount": 42
      }
    ],
    "recentOrders": [...]
  }
}
```

---

### 9. Get All Customers
**Endpoint:** `GET /admin-users/customers`  
**Auth:** Required (Admin)

**Query Parameters:**
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439001",
    "fullName": "John Doe",
    "email": "john@example.com",
    "phone": "+977981234567",
    "totalOrders": 15,
    "totalSpent": 12500,
    "lastOrderDate": "2024-01-20T15:45:00.000Z",
    "isBlocked": false
  }
]
```

---

### 10. Get Customer Details
**Endpoint:** `GET /admin-users/customers/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Detailed customer object with all orders

---

### 11. Create Rider
**Endpoint:** `POST /admin-users/riders`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "name": "Ram Kumar",
  "email": "ram@example.com",
  "phone": "+977981234567"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "rider": {
    "_id": "507f1f77bcf86cd799439050",
    "fullName": "Ram Kumar",
    "email": "ram@example.com",
    "phone": "+977981234567",
    "role": "rider",
    "isRiderActive": true
  }
}
```

---

### 12. Get All Riders
**Endpoint:** `GET /admin-users/riders`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439050",
    "fullName": "Ram Kumar",
    "email": "ram@example.com",
    "phone": "+977981234567",
    "role": "rider",
    "isRiderActive": true,
    "totalDeliveries": 45,
    "averageRating": 4.8
  }
]
```

---

### 13. Get All Leads
**Endpoint:** `GET /admin-users/leads`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439060",
    "rider": {
      "_id": "507f1f77bcf86cd799439050",
      "fullName": "Ram Kumar"
    },
    "name": "Restaurant Lead",
    "phone": "+977981234567",
    "email": "contact@restaurant.com",
    "status": "new",
    "notes": "Interested in partnership",
    "createdAt": "2024-01-20T15:45:00.000Z"
  }
]
```

---

## Rider Endpoints

### 1. Get Available Orders
**Endpoint:** `GET /rider/orders/available`  
**Auth:** Required (Rider)

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439020",
      "orderId": "ORD-1705856400000",
      "items": [...],
      "totalAmount": 590,
      "status": "Ready for Delivery",
      "deliveryAddress": {
        "addressLine": "123 Main Street",
        "city": "Pokhara",
        "phone": "+977981234567"
      },
      "userLocation": {
        "lat": 28.193823,
        "lng": 83.977514
      },
      "distance": 2.5,
      "user": {
        "fullName": "John Doe",
        "phone": "+977981234567"
      }
    }
  ]
}
```

---

### 2. Accept Order for Delivery
**Endpoint:** `PUT /rider/orders/:id/accept`  
**Auth:** Required (Rider)

**Request Body:** Empty

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Order accepted",
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "status": "Out for Delivery",
    "rider": "507f1f77bcf86cd799439050",
    "assignedAt": "2024-01-21T17:30:00.000Z"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Order is already assigned to a rider"
}
```

---

### 3. Mark Order as Delivered
**Endpoint:** `PUT /rider/orders/:id/deliver`  
**Auth:** Required (Rider)

**Request Body:** Empty

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Order delivered",
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "status": "Delivered",
    "deliveredAt": "2024-01-21T18:15:00.000Z"
  }
}
```

---

### 4. Mark Order as Paid
**Endpoint:** `PUT /rider/orders/:id/paid`  
**Auth:** Required (Rider)

**Request Body:** Empty

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Payment received",
  "data": {
    "_id": "507f1f77bcf86cd799439020",
    "paymentStatus": "Paid"
  }
}
```

---

### 5. Get My Orders (Rider)
**Endpoint:** `GET /rider/orders/my`  
**Auth:** Required (Rider)

**Query Parameters:**
- `status`: Filter by status
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):** Array of rider's orders

---

### 6. Create Lead
**Endpoint:** `POST /rider/leads`  
**Auth:** Required (Rider)

**Request Body:**
```json
{
  "name": "New Restaurant",
  "phone": "+977981234567",
  "email": "contact@newrestaurant.com",
  "notes": "Interested in our delivery service"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "lead": {
    "_id": "507f1f77bcf86cd799439060",
    "rider": "507f1f77bcf86cd799439050",
    "name": "New Restaurant",
    "phone": "+977981234567",
    "email": "contact@newrestaurant.com",
    "notes": "Interested in our delivery service",
    "status": "new"
  }
}
```

---

### 7. Get My Leads
**Endpoint:** `GET /rider/leads`  
**Auth:** Required (Rider)

**Response (200 OK):** Array of rider's leads

---

## Daily Special Endpoints

### 1. Get Active Daily Specials
**Endpoint:** `GET /daily-specials/active`  
**Auth:** Public

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439070",
    "title": "Monday Special",
    "slug": "monday-special",
    "description": "50% off on all biryani",
    "image": {
      "url": "https://res.cloudinary.com/...",
      "imageId": "daily-specials/monday_xyz"
    },
    "discountPercentage": 50,
    "validFrom": "2024-01-22T00:00:00.000Z",
    "validUntil": "2024-01-22T23:59:59.000Z",
    "isActive": true
  }
]
```

---

### 2. Get Daily Special by Slug
**Endpoint:** `GET /daily-specials/:slug`  
**Auth:** Public

**Response (200 OK):** Single daily special object

---

### 3. Get All Daily Specials (Admin)
**Endpoint:** `GET /daily-specials`  
**Auth:** Required (Admin)

**Response (200 OK):** Array of all daily specials

---

### 4. Create Daily Special (Admin)
**Endpoint:** `POST /daily-specials`  
**Auth:** Required (Admin)  
**Multipart:** Form Data

**Request Body (Form Data):**
```
title: "Tuesday Special"
description: "Buy 1 Get 1 on selected items"
discountPercentage: 50
validFrom: "2024-01-23T00:00:00.000Z"
validUntil: "2024-01-23T23:59:59.000Z"
image: <File>
isActive: true
```

**Response (201 Created):** Daily special object

---

### 5. Update Daily Special (Admin)
**Endpoint:** `PUT /daily-specials/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Updated daily special

---

### 6. Delete Daily Special (Admin)
**Endpoint:** `DELETE /daily-specials/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Daily special deleted"
}
```

---

## Post (Blog) Endpoints

### 1. Get Published Posts
**Endpoint:** `GET /posts/published`  
**Auth:** Public

**Query Parameters:**
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439080",
    "title": "How to make perfect biryani",
    "slug": "how-to-make-perfect-biryani",
    "excerpt": "Learn the secrets of perfect biryani",
    "content": "Detailed recipe content...",
    "featuredImage": {
      "url": "https://res.cloudinary.com/...",
      "imageId": "posts/biryani_abc"
    },
    "category": {
      "_id": "507f1f77bcf86cd799439012",
      "name": "Recipes",
      "slug": "recipes"
    },
    "tags": [...],
    "status": "published",
    "type": "blog",
    "author": "Admin User",
    "createdAt": "2024-01-10T08:00:00.000Z",
    "views": 150
  }
]
```

---

### 2. Get Posts by Category Slug
**Endpoint:** `GET /posts/category/:slug`  
**Auth:** Public

**Response (200 OK):** Array of posts in category

---

### 3. Get Posts by Tag Slug
**Endpoint:** `GET /posts/tag/:slug`  
**Auth:** Public

**Response (200 OK):** Array of posts with tag

---

### 4. Get Post by Slug
**Endpoint:** `GET /posts/slug/:slug`  
**Auth:** Public

**Response (200 OK):** Single post object (published only)

---

### 5. Get All Posts (Admin)
**Endpoint:** `GET /posts`  
**Auth:** Required (Admin)

**Query Parameters:**
- `type`: blog | caseStudy
- `status`: draft | published
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):** Array of all posts

---

### 6. Get Post by ID (Admin)
**Endpoint:** `GET /posts/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Complete post object

---

### 7. Create Post (Admin)
**Endpoint:** `POST /posts`  
**Auth:** Required (Admin)  
**Multipart:** Form Data

**Request Body (Form Data):**
```
title: "New Recipe Guide"
excerpt: "Master the art of cooking"
content: "Detailed content..."
category: "507f1f77bcf86cd799439012"
tags: ["cooking", "recipe"]
type: "blog"
status: "draft"
author: "Admin Name"
featuredImage: <File>
images: <Files>
```

**Response (201 Created):** Post object

---

### 8. Update Post (Admin)
**Endpoint:** `PUT /posts/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Updated post object

---

### 9. Delete Post (Admin)
**Endpoint:** `DELETE /posts/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Post deleted"
}
```

---

### 10. Upload Image
**Endpoint:** `POST /posts/upload-image`  
**Auth:** Required (Admin)  
**Multipart:** Form Data

**Request Body (Form Data):**
```
image: <File>
```

**Response (200 OK):**
```json
{
  "success": true,
  "url": "https://res.cloudinary.com/...",
  "public_id": "posts/image_abc"
}
```

---

## Inquiry Endpoints

### 1. Create Inquiry
**Endpoint:** `POST /inquiries`  
**Auth:** Public

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+977981234567",
  "subject": "Partnership inquiry",
  "message": "I am interested in partnering with your business"
}
```

**Response (201 Created):**
```json
{
  "_id": "507f1f77bcf86cd799439090",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+977981234567",
  "subject": "Partnership inquiry",
  "message": "I am interested in partnering with your business",
  "status": "new",
  "createdAt": "2024-01-21T17:00:00.000Z"
}
```

---

### 2. Get All Inquiries (Admin)
**Endpoint:** `GET /inquiries`  
**Auth:** Required (Admin)

**Response (200 OK):** Array of all inquiries

---

### 3. Mark Inquiry as Seen (Admin)
**Endpoint:** `PUT /inquiries/:id/seen`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "_id": "507f1f77bcf86cd799439090",
  "status": "seen"
}
```

---

### 4. Reply to Inquiry (Admin)
**Endpoint:** `PUT /inquiries/:id/reply`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "replyMessage": "Thank you for your inquiry. We will contact you soon."
}
```

**Response (200 OK):**
```json
{
  "_id": "507f1f77bcf86cd799439090",
  "status": "replied",
  "replyMessage": "Thank you for your inquiry. We will contact you soon."
}
```

---

### 5. Delete Inquiry (Admin)
**Endpoint:** `DELETE /inquiries/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Inquiry deleted"
}
```

---

## Tag Endpoints

### 1. Get All Tags
**Endpoint:** `GET /tags`  
**Auth:** Public

**Response (200 OK):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439100",
    "name": "Spicy",
    "slug": "spicy",
    "description": "Spicy dishes"
  }
]
```

---

### 2. Get Tag by Slug
**Endpoint:** `GET /tags/:slug`  
**Auth:** Public

**Response (200 OK):** Single tag object

---

### 3. Create Tag (Admin)
**Endpoint:** `POST /tags`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "name": "Vegetarian",
  "description": "Vegetarian friendly dishes"
}
```

**Response (201 Created):** Tag object

---

### 4. Update Tag (Admin)
**Endpoint:** `PUT /tags/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Updated tag object

---

### 5. Delete Tag (Admin)
**Endpoint:** `DELETE /tags/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Tag deleted"
}
```

---

## Inventory Endpoints

### 1. Create Inventory Item (Admin)
**Endpoint:** `POST /inventory`  
**Auth:** Required (Admin)

**Request Body:**
```json
{
  "name": "Chicken",
  "quantity": 50,
  "unit": "kg",
  "expiryDate": "2024-02-21T00:00:00.000Z",
  "supplier": "Local Supplier"
}
```

**Response (201 Created):**
```json
{
  "_id": "507f1f77bcf86cd799439110",
  "name": "Chicken",
  "quantity": 50,
  "unit": "kg",
  "expiryDate": "2024-02-21T00:00:00.000Z",
  "supplier": "Local Supplier"
}
```

---

### 2. Get All Inventory (Admin)
**Endpoint:** `GET /inventory`  
**Auth:** Required (Admin)

**Query Parameters:**
- `skip`: Pagination
- `limit`: Items per page

**Response (200 OK):** Array of inventory items

---

### 3. Get Inventory by ID (Admin)
**Endpoint:** `GET /inventory/:id`  
**Auth:** Required (Admin)

**Response (200 OK):** Single inventory item

---

### 4. Update Inventory (Admin)
**Endpoint:** `PUT /inventory/:id`  
**Auth:** Required (Admin)

**Request Body:** Same as Create (all fields optional)

**Response (200 OK):** Updated inventory item

---

### 5. Delete Inventory (Admin)
**Endpoint:** `DELETE /inventory/:id`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Inventory deleted"
}
```

---

### 6. Get Inventory Stats (Admin)
**Endpoint:** `GET /inventory/stats`  
**Auth:** Required (Admin)

**Response (200 OK):**
```json
{
  "success": true,
  "stats": {
    "totalItems": 15,
    "lowStockItems": 3,
    "expiringSoon": 2,
    "totalValue": 25000
  }
}
```

---

## Data Models

### User Model
```json
{
  "_id": ObjectId,
  "fullName": String,
  "email": String (unique),
  "phone": String,
  "password": String (hashed, hidden by default),
  "authProvider": "local" | "google",
  "googleId": String,
  "photo": String (URL),
  "photoPublicId": String,
  "deliveryAddress": {
    "addressLine": String,
    "city": String,
    "state": String,
    "zipCode": String
  },
  "role": "user" | "rider",
  "isRiderActive": Boolean,
  "totalPoints": Number,
  "usedPromos": [
    {
      "code": String,
      "orderId": ObjectId,
      "usedAt": Date
    }
  ],
  "resetPasswordToken": String,
  "resetPasswordExpiresAt": Date,
  "lastLogin": Date,
  "createdAt": Date,
  "updatedAt": Date
}
```

### Food Model
```json
{
  "_id": ObjectId,
  "name": String,
  "slug": String (unique),
  "description": String,
  "image": {
    "url": String,
    "imageId": String
  },
  "category": ObjectId (ref: FoodCategory),
  "isAvailable": Boolean,
  "orderCount": Number,
  "variants": [
    {
      "_id": ObjectId,
      "label": String,
      "price": Number,
      "discountedPrice": Number,
      "points": Number,
      "isAvailable": Boolean
    }
  ],
  "createdAt": Date,
  "updatedAt": Date
}
```

### Order Model
```json
{
  "_id": ObjectId,
  "user": ObjectId (ref: User),
  "orderId": String (unique),
  "items": [
    {
      "foodItem": ObjectId (ref: Food),
      "name": String,
      "quantity": Number,
      "priceAtPurchase": Number,
      "isFree": Boolean
    }
  ],
  "subTotal": Number,
  "discountAmount": Number,
  "deliveryCharge": Number,
  "totalAmount": Number,
  "pointsEarned": Number,
  "pointsRedeemed": Number,
  "status": "Pending" | "Preparing" | "Ready for Delivery" | "Out for Delivery" | "Delivered" | "Cancelled",
  "promoCode": String,
  "deliveryAddress": {
    "addressLine": String,
    "city": String,
    "phone": String
  },
  "userLocation": {
    "lat": Number,
    "lng": Number
  },
  "distance": Number,
  "rider": ObjectId (ref: User),
  "assignedAt": Date,
  "deliveredAt": Date,
  "requestedDeliveryTime": Date,
  "paymentMethod": "COD" | "Online",
  "paymentStatus": "Pending" | "Paid",
  "createdAt": Date,
  "updatedAt": Date
}
```

### Cart Model
```json
{
  "_id": ObjectId,
  "user": ObjectId (ref: User),
  "items": [
    {
      "_id": ObjectId,
      "foodItem": ObjectId (ref: Food),
      "variantId": ObjectId,
      "quantity": Number
    }
  ],
  "createdAt": Date,
  "updatedAt": Date
}
```

### PromoCode Model
```json
{
  "_id": ObjectId,
  "code": String (unique, uppercase),
  "description": String,
  "benefitTypes": ["percentage" | "fixed_amount" | "free_item"],
  "discountValue": Number,
  "freeItemIds": [
    {
      "itemId": ObjectId (ref: Food),
      "variantId": ObjectId
    }
  ],
  "minOrderAmount": Number,
  "expiryDate": Date,
  "isActive": Boolean,
  "createdAt": Date
}
```

### Category Model
```json
{
  "_id": ObjectId,
  "name": String,
  "slug": String (unique),
  "description": String,
  "seoTitle": String,
  "seoDescription": String,
  "parent": ObjectId | null,
  "createdAt": Date,
  "updatedAt": Date
}
```

---

## Error Handling

### Standard Error Response Format
```json
{
  "success": false,
  "message": "Error message"
}
```

### HTTP Status Codes
- **200**: OK - Request successful
- **201**: Created - Resource created successfully
- **400**: Bad Request - Invalid request data
- **401**: Unauthorized - Authentication required
- **403**: Forbidden - Access denied
- **404**: Not Found - Resource not found
- **409**: Conflict - Resource already exists
- **500**: Internal Server Error - Server error

---

## Rate Limiting

- Standard Rate Limit: 100 requests per 15 minutes per IP
- Auth endpoints: 5 requests per 15 minutes per IP (to prevent brute force)

---

## CORS & Security

### CORS Headers
```
Access-Control-Allow-Origin: [allowed origins]
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH
Access-Control-Allow-Headers: Content-Type, Accept
Access-Control-Allow-Credentials: true
```

### Security Headers
- Strict-Transport-Security: HSTS enabled (1 year)
- X-Frame-Options: deny
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Content-Security-Policy: Configured for images, fonts, and scripts

---

## File Upload Configuration

### Supported File Types
- Images: JPG, PNG, GIF, WebP
- Max Size: 10MB per file
- Upload Service: Cloudinary

### Upload Endpoints
- **Food Images**: `/foods` (POST/PUT)
- **User Profile Photo**: `/users/profile` (PUT)
- **Daily Special Images**: `/daily-specials` (POST/PUT)
- **Post Images**: `/posts` (POST/PUT)

---

## Testing the API

### Recommended Tools
- Postman: API testing
- Thunder Client: VS Code extension
- cURL: Command line
- Axios: JavaScript client

### Environment Variables Required
```
PORT=5001
DATABASE_URL=mongodb://...
JWT_SECRET=your_secret_key
ADMIN_JWT_SECRET=admin_secret_key
GOOGLE_CLIENT_ID=google_client_id
GOOGLE_CLIENT_SECRET=google_client_secret
NODE_ENV=development
CLOUDINARY_NAME=cloudinary_name
CLOUDINARY_API_KEY=cloudinary_api_key
CLOUDINARY_API_SECRET=cloudinary_api_secret
EMAIL_SENDER=email@example.com
```

---

## Additional Notes

1. **DateTime Format**: All timestamps are in ISO 8601 format (UTC)
2. **Pagination**: Default limit is 10, default skip is 0
3. **Sorting**: Most list endpoints sort by `createdAt` descending
4. **IDs**: All IDs are MongoDB ObjectIds (24-character hex strings)
5. **Currency**: All amounts are in Nepali Rupees (Rs.)
6. **Location**: Latitude/Longitude coordinates in decimal degrees
7. **Phone Format**: Should include country code (e.g., +977xxxxxxxxxx for Nepal)
8. **Email Validation**: Standard email format required
9. **Password Requirements**: Minimum 8 characters recommended
10. **Token Refresh**: Tokens expire after 6 hours; user must re-login

---

## Support & Version

**API Version**: 1.0.0  
**Last Updated**: January 2024  
**Support Email**: support@tastykhaja.com

---

Generated for: Mobile Development Team  
Document Type: API Reference Documentation
