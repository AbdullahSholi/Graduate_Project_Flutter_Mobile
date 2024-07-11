![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image1.png)

Computer Engineering Department

**Software Graduate Project**

**MatjarCom**

> **Students:**\
> Abdullah Ghassan Sholi\
> Omar Farouq Quzmar
>
> **Supervisors:**\
> Dr.Samer Arandi\
> Dr.Muhannad Al-Jabi

**Acknowledgment**

I would like to extend my heartfelt gratitude to everyone who supported
and\
contributed to the development of the MatjarCom application. Special
thanks to my academic advisor for their invaluable guidance and feedback
throughout this project. I am also deeply grateful to my family and
friends for their unwavering support and encouragement. Additionally, I
appreciate the open-source community and the\
developers behind the libraries and tools that made this project
possible. Lastly, I thank all the beta testers whose insightful feedback
helped refine and improve the application.

**Abstract**

MatjarCom is a comprehensive multi-vendor e-commerce platform designed
to empower merchants by providing a digital marketplace to create and
manage their online stores.

The application allows merchants to design and customize their stores,
manage products and categories, communicate with customers, and track
their sales\
performance. Customers benefit from a unified shopping experience across
multiple stores with features such as product browsing, purchasing, and
reviewing. The app is built using Flutter for the front end and Node.js
with MongoDB for the backend, ensuring a responsive and scalable
architecture. MatjarCom also includes robust security measures,
real-time communication capabilities, and support for both English and
Arabic languages. The application is hosted on Render for backend
services, ensuring reliable and scalable deployment.

**Contents**

<table style="width:100%;">
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>1</strong></th>
<th colspan="8"><blockquote>
<p><strong>Introduction</strong></p>
</blockquote></th>
<th><strong>5</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>2</strong></td>
<td colspan="8"><blockquote>
<p><strong>Constraints &amp; Earlier Work</strong></p>
</blockquote></td>
<td><strong>5</strong></td>
</tr>
<tr class="even">
<td rowspan="8"><strong>3</strong></td>
<td>2.1</td>
<td colspan="7">Constraints </td>
<td>5</td>
</tr>
<tr class="odd">
<td colspan="2">2.1.1</td>
<td colspan="6">Technological Constraints </td>
<td>5</td>
</tr>
<tr class="even">
<td colspan="2">2.1.2</td>
<td colspan="6">Resource Constraints </td>
<td>5</td>
</tr>
<tr class="odd">
<td colspan="2">2.1.3</td>
<td colspan="6">Operational Constraints </td>
<td>5</td>
</tr>
<tr class="even">
<td colspan="2">2.1.4</td>
<td colspan="4">User Experience Constraints</td>
<td colspan="2"><blockquote>
<p></p>
</blockquote></td>
<td>5</td>
</tr>
<tr class="odd">
<td>2.2</td>
<td colspan="7">Constraints </td>
<td>5</td>
</tr>
<tr class="even">
<td colspan="2">2.2.1</td>
<td>Earlier Work</td>
<td colspan="5"></td>
<td>5</td>
</tr>
<tr class="odd">
<td colspan="8"><blockquote>
<p><strong>Literature Review</strong></p>
</blockquote></td>
<td><strong>6</strong></td>
</tr>
<tr class="even">
<td rowspan="14"><strong>4</strong></td>
<td>3.1</td>
<td colspan="6">E-commerce Platforms and Marketplaces</td>
<td></td>
<td>6</td>
</tr>
<tr class="odd">
<td>3.2</td>
<td colspan="7">Multi-Vendor Systems </td>
<td>6</td>
</tr>
<tr class="even">
<td>3.3</td>
<td colspan="3">Security in E-commerce</td>
<td colspan="4"></td>
<td>6</td>
</tr>
<tr class="odd">
<td>3.4</td>
<td colspan="7">Mobile Commerce Trends </td>
<td>6</td>
</tr>
<tr class="even">
<td>3.5</td>
<td colspan="5"><blockquote>
<p>Customer Engagement and Retention</p>
</blockquote></td>
<td colspan="2">
.</td>
<td>6</td>
</tr>
<tr class="odd">
<td colspan="8"><blockquote>
<p><strong>Methodology</strong></p>
</blockquote></td>
<td><strong>6</strong></td>
</tr>
<tr class="even">
<td>4.1</td>
<td colspan="4">Technology Stack Selection</td>
<td colspan="3"></td>
<td>6</td>
</tr>
<tr class="odd">
<td colspan="2">4.1.1</td>
<td colspan="6">Frontend (Flutter) </td>
<td>6</td>
</tr>
<tr class="even">
<td colspan="2">4.1.2</td>
<td colspan="6">Backend (Node.js with MongoDB) </td>
<td>6</td>
</tr>
<tr class="odd">
<td colspan="2">4.1.3</td>
<td colspan="6">Security Implementation </td>
<td>7</td>
</tr>
<tr class="even">
<td colspan="2">4.1.4</td>
<td colspan="6">Database Design </td>
<td>7</td>
</tr>
<tr class="odd">
<td colspan="2">4.1.5</td>
<td colspan="6">Frontend Development </td>
<td>7</td>
</tr>
<tr class="even">
<td colspan="2">4.1.6</td>
<td colspan="6">Backend Development </td>
<td>7</td>
</tr>
<tr class="odd">
<td colspan="2">4.1.7</td>
<td colspan="5">Admin Dashboard Implementation</td>
<td><blockquote>
<p></p>
</blockquote></td>
<td>7</td>
</tr>
</tbody>
</table>



<table>
<colgroup>
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th rowspan="3"><strong>5</strong></th>
<th colspan="2">4.1.8</th>
<th colspan="8">Messaging System Integration</th>
<th colspan="4">
.</th>
<th>7</th>
</tr>
<tr class="odd">
<th colspan="2">4.1.9</th>
<th colspan="4"><blockquote>
<p>Help &amp; Support</p>
</blockquote></th>
<th colspan="8"><blockquote>
<p> .
. .</p>
</blockquote></th>
<th>7</th>
</tr>
<tr class="header">
<th colspan="14"><blockquote>
<p><strong>Results &amp; Discussion</strong></p>
</blockquote></th>
<th><strong>8</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="8"><strong>6</strong></td>
<td>5.1</td>
<td colspan="4">Technologies Used</td>
<td colspan="9"></td>
<td>8</td>
</tr>
<tr class="even">
<td colspan="2">5.1.1</td>
<td colspan="12">Mobile Frontend ( Flutter ) </td>
<td>8</td>
</tr>
<tr class="odd">
<td colspan="2">5.1.2</td>
<td colspan="8">Web Frontend ( Flutter Web )</td>
<td colspan="4">
.</td>
<td>8</td>
</tr>
<tr class="even">
<td colspan="2">5.1.3</td>
<td colspan="12">Backend ( NodeJS ) </td>
<td>8</td>
</tr>
<tr class="odd">
<td colspan="2">5.1.4</td>
<td colspan="12">Database ( NoSQL MongoDB &amp; Firebase ) </td>
<td>9</td>
</tr>
<tr class="even">
<td colspan="2">5.1.5</td>
<td colspan="12">API Testing &amp; Documentation ( Postman ) </td>
<td>11</td>
</tr>
<tr class="odd">
<td colspan="2">5.1.6</td>
<td colspan="12">Web Application Features: </td>
<td>12</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p><strong>User-Friendly Interface</strong></p>
</blockquote></td>
<td><strong>12</strong></td>
</tr>
<tr class="odd">
<td rowspan="44"><strong>7</strong></td>
<td>6.1</td>
<td colspan="13">Splash Screen </td>
<td>12</td>
</tr>
<tr class="even">
<td>6.2</td>
<td colspan="13">Onboarding Page </td>
<td>13</td>
</tr>
<tr class="odd">
<td>6.3</td>
<td colspan="2">Login Page</td>
<td colspan="11"></td>
<td>14</td>
</tr>
<tr class="even">
<td>6.4</td>
<td colspan="13">Merchant Side </td>
<td>15</td>
</tr>
<tr class="odd">
<td colspan="2">6.4.1</td>
<td colspan="3">Login Page</td>
<td colspan="9"></td>
<td>15</td>
</tr>
<tr class="even">
<td colspan="2">6.4.2</td>
<td colspan="12">Register Page </td>
<td>15</td>
</tr>
<tr class="odd">
<td colspan="2">6.4.3</td>
<td colspan="12">Main Page &amp; Personal Information </td>
<td>16</td>
</tr>
<tr class="even">
<td colspan="2">6.4.4</td>
<td colspan="12">Payment Information &amp; Store Management </td>
<td>17</td>
</tr>
<tr class="odd">
<td colspan="2">6.4.5</td>
<td colspan="12">Design your store</td>
<td>17</td>
</tr>
<tr class="even">
<td colspan="2">6.4.6</td>
<td colspan="8"><blockquote>
<p>display &amp; edit store information</p>
</blockquote></td>
<td colspan="4"><blockquote>
<p></p>
</blockquote></td>
<td>22</td>
</tr>
<tr class="odd">
<td colspan="2">6.4.7</td>
<td colspan="12">Social Media Accounts &amp; Chat System</td>
<td>23</td>
</tr>
<tr class="even">
<td colspan="2">6.4.8</td>
<td colspan="12">Chating pages &amp; Custom Notifications </td>
<td>23</td>
</tr>
<tr class="odd">
<td colspan="2">6.4.9</td>
<td colspan="12">FAQ Page, delete store &amp; Logout </td>
<td>24</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p>6.4.10 Store Statistics Page </p>
</blockquote></td>
<td>24</td>
</tr>
<tr class="odd">
<td>6.5</td>
<td colspan="3">Customer Side</td>
<td colspan="10"></td>
<td>25</td>
</tr>
<tr class="even">
<td colspan="2">6.5.1</td>
<td colspan="10">Customer Register Page, main page &amp; Drawer</td>
<td colspan="2"></td>
<td>25</td>
</tr>
<tr class="odd">
<td colspan="2">6.5.2</td>
<td colspan="12">Display &amp; Edit Customer Profile, Enter to Shopping
cart and favorite products . .</td>
<td>26</td>
</tr>
<tr class="even">
<td colspan="2">6.5.3</td>
<td colspan="9">Help &amp; Support and specific store</td>
<td colspan="3"></td>
<td>27</td>
</tr>
<tr class="odd">
<td colspan="2">6.5.4</td>
<td colspan="11">Favorite Products, Enter to specific product &amp; add
product to cart successfully!</td>
<td>.</td>
<td>28</td>
</tr>
<tr class="even">
<td colspan="2">6.5.5</td>
<td colspan="4">Shopping Cart</td>
<td colspan="8"></td>
<td>29</td>
</tr>
<tr class="odd">
<td colspan="2">6.5.6</td>
<td colspan="6">Rating &amp; Reviews</td>
<td colspan="6"></td>
<td>30</td>
</tr>
<tr class="even">
<td colspan="2">6.5.7</td>
<td colspan="3"><blockquote>
<p>Notifications</p>
</blockquote></td>
<td colspan="9"><blockquote>
<p></p>
</blockquote></td>
<td>31</td>
</tr>
<tr class="odd">
<td colspan="2">6.5.8</td>
<td colspan="4"><blockquote>
<p>Help &amp; Support</p>
</blockquote></td>
<td colspan="8"><blockquote>
<p> .
. .</p>
</blockquote></td>
<td>32</td>
</tr>
<tr class="even">
<td colspan="2">6.5.9</td>
<td colspan="4"><blockquote>
<p>Help &amp; Support</p>
</blockquote></td>
<td colspan="8"><blockquote>
<p> .
. .</p>
</blockquote></td>
<td>33</td>
</tr>
<tr class="odd">
<td colspan="6"><blockquote>
<p>6.5.10 Chatting Page</p>
</blockquote></td>
<td colspan="8"></td>
<td>34</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p>6.5.11 Create a Custom Notification </p>
</blockquote></td>
<td>35</td>
</tr>
<tr class="odd">
<td colspan="14"><blockquote>
<p>6.5.12 Forgot &amp; Reset Password </p>
</blockquote></td>
<td>36</td>
</tr>
<tr class="even">
<td>6.6</td>
<td colspan="13">Admin Dashboard Side </td>
<td>38</td>
</tr>
<tr class="odd">
<td colspan="2">6.6.1</td>
<td colspan="3">Login Page</td>
<td colspan="9"></td>
<td>38</td>
</tr>
<tr class="even">
<td colspan="2">6.6.2</td>
<td colspan="3">Login Page</td>
<td colspan="9"></td>
<td>39</td>
</tr>
<tr class="odd">
<td colspan="2">6.6.3</td>
<td colspan="12">Register Page </td>
<td>39</td>
</tr>
<tr class="even">
<td colspan="2">6.6.4</td>
<td colspan="12">Forgot &amp; Reset Password Page </td>
<td>40</td>
</tr>
<tr class="odd">
<td colspan="2">6.6.5</td>
<td colspan="12">Admin Dashboard </td>
<td>40</td>
</tr>
<tr class="even">
<td colspan="2">6.6.6</td>
<td colspan="12">Add &amp; Delete Category </td>
<td>41</td>
</tr>
<tr class="odd">
<td colspan="2">6.6.7</td>
<td colspan="12">Store &amp; merchants Tables </td>
<td>42</td>
</tr>
<tr class="even">
<td colspan="2">6.6.8</td>
<td colspan="6">Tasks &amp; Messages</td>
<td colspan="6"></td>
<td>42</td>
</tr>
<tr class="odd">
<td colspan="2">6.6.9</td>
<td colspan="5">Create new task</td>
<td colspan="7"></td>
<td>43</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p>6.6.10 Delete Task </p>
</blockquote></td>
<td>43</td>
</tr>
<tr class="odd">
<td colspan="14"><blockquote>
<p>6.6.11 Enter to chat with specific merchant </p>
</blockquote></td>
<td>44</td>
</tr>
<tr class="even">
<td colspan="9"><blockquote>
<p>6.6.12 Delete Merchant or Store</p>
</blockquote></td>
<td colspan="5"></td>
<td>44</td>
</tr>
<tr class="odd">
<td colspan="14"><blockquote>
<p>6.6.13 Admin account </p>
</blockquote></td>
<td>45</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p>6.6.14 Billing Information </p>
</blockquote></td>
<td>45</td>
</tr>
<tr class="odd">
<td colspan="14"><blockquote>
<p>6.6.15 Admin account </p>
</blockquote></td>
<td>46</td>
</tr>
<tr class="even">
<td colspan="14"><blockquote>
<p><strong>Result &amp; Discussion</strong></p>
</blockquote></td>
<td><strong>46</strong></td>
</tr>
</tbody>
</table>



**1** **Introduction**

In the digital age, e-commerce platforms have become essential for
businesses to reach a broader audience and enhance their sales
potential. MatjarCom aims to fill the gap in the market for a robust,
user-friendly multi-vendor platform that facilitates merchants to
cre-ate, customize, and manage their online stores efficiently. This
application is designed to cater to both merchants and customers,
providing a seamless experience for store man-agement and product
purchasing. Leveraging modern technologies and best practices, MatjarCom
offers a comprehensive solution for businesses to thrive in the
competitive online marketplace.

**2** **Constraints & Earlier Work**

**2.1** **Constraints**

**2.1.1** **Technological Constraints**

Compatibility: Ensuring the application is compatible with various
devices and operating systems.

Performance: Maintaining optimal performance and responsiveness for both
the front end and back end.

Security: Implementing robust security measures to protect user data and
transactions.

**2.1.2** **Resource Constraints**

Time: Limited time available for development

**2.1.3** **Operational Constraints**

Scalability: Designing the system to handle increasing numbers of users
and transactions. Localization: Supporting multiple languages and
regional settings to cater to a diverse user base.

**2.1.4** **User Experience Constraints**

Usability: Ensuring the application is intuitive and easy to use for
both merchants and customers.

Accessibility: Making the app accessible to users with varying levels of
technical exper-tise.

**2.2** **Constraints**

**2.2.1** **Earlier Work**

The concept of multi-vendor marketplaces is not new, and several
established platforms

like Amazon, eBay, and Etsy have paved the way in this domain. These
platforms provide

merchants with an opportunity to reach a global audience, offering
extensive features for

product listing, inventory management, and customer engagement. However,
many of

these platforms have limitations in terms of customization and
flexibility for individual

merchants.

> Prior to MatjarCom, similar efforts have been made to develop
> multi-vendor appli-

cations, such as Shopify, WooCommerce, and Magento. These platforms
offer varying

degrees of functionality and customization but often come with a steep
learning curve or

cost barriers for small to medium-sized businesses.



MatjarCom differentiates itself by providing a more accessible,
customizable, and lo-calized solution, especially for markets that
require bilingual support. It leverages modern technologies and a
modular architecture to offer a user-friendly and flexible platform for
both merchants and customers.

**3** **Literature Review**

**3.1** **E-commerce Platforms and Marketplaces**

Research on e-commerce platforms highlights the importance of user
experience, cus-tomization, and scalability. Platforms like Shopify and
Magento provide extensive cus-tomization options but may be challenging
for less technical users. Studies suggest that platforms offering a
balance between ease of use and customization tend to be more successful
(Smith, 2020).

**3.2** **Multi-Vendor Systems**

Multi-vendor systems enable multiple sellers to operate within a single
marketplace, pro-viding benefits like reduced operational costs and
expanded reach. However, these sys-tems also present challenges in terms
of managing diverse product catalogs and ensuring fair distribution of
resources (Johnson & Wang, 2019).

**3.3** **Security in E-commerce**

Security is a critical concern for e-commerce platforms, with risks
ranging from data breaches to fraudulent transactions. Implementing
secure authentication methods, data encryption, and robust transaction
monitoring are essential strategies for mitigating these risks (Doe,
2021).

**3.4** **Mobile Commerce Trends**

With the rise of smartphones, mobile commerce has become increasingly
prevalent. Re-search indicates that user-friendly mobile interfaces and
seamless integration of payment systems are crucial for the success of
mobile e-commerce applications (Lee, 2022).

**3.5** **Customer Engagement and Retention**

Effective customer engagement strategies, such as personalized marketing
and responsive customer service, significantly impact customer retention
and satisfaction. Multi-vendor platforms must provide tools for
merchants to interact with their customers and manage their
relationships effectively (Patel, 2020).

**4** **Methodology**

**4.1** **Technology Stack Selection**

**4.1.1** **Frontend (Flutter)**

Utilize Flutter SDK for cross-platform mobile app development. Ensure
compatibility with both iOS and Android platforms.

**4.1.2** **Backend (Node.js with MongoDB)**

Node.js for server-side logic and API development with Layered
Architecture.

MongoDB for NoSQL database to store dynamic data (e.g., merchant
details, store in-

formation).



Use packages like bcrypt for password hashing, nodemailer for email
communication, and express for RESTful API development.

**4.1.3** **Security Implementation**

Authentication: Implement JWT (Json Web Token) for secure authentication
of both merchants and customers.

Use bcrypt for password hashing to protect user credentials.

Authorization: Implement separate authorization logic in each endpoint
to validate user type (customer, merchant, admin) based on the JWT
payload.˙\
Ensure API security with CORS, HTTP headers, and rate-limiting
(express-rate-limit) to prevent abuse and protect against common
vulnerabilities.

**4.1.4** **Database Design**

MongoDB: Design collections for customers, merchants, admin, products,
store informa-tion, etc.

Optimize schema for fast data retrieval and scalability.

Maintain data integrity with appropriate indexes and validations.

**4.1.5** **Frontend Development**

Flutter: Design responsive UI components using Flutter widgets.

Implement state management (e.g., setState(*{}*)) for managing app state
and data flow.

Utilize flutter translate for supporting multiple languages (Arabic and
English).

**4.1.6** **Backend Development**

Node.js: Develop RESTful APIs to handle CRUD operations for customers,
merchants, admin functionalities.

Integrate third-party APIs (e.g., Lahza for payments) securely.
Implement server-side validation and error handling for robustness.

**4.1.7** **Admin Dashboard Implementation**

Design admin dashboard for managing merchants, customer support,
analytics, and con-tent management.

Implement CRUD operations specific to admin functionalities. Ensure
dashboard is secure with authentication for admin access.

**4.1.8** **Messaging System Integration**

Integrate messaging systems for customer-merchant and merchant-admin
communica-tions.

**4.1.9** **Help & Support**

implement a support system where customers can contact admin via email
for complaints and queries.



Use Node.js with nodemailer for secure email communication.

Provide a user-friendly interface for customers to initiate and track
their support requests.

**5** **Results & Discussion**

The results of the study are presented in this section.

**5.1** **Technologies Used**

**5.1.1** **Mobile Frontend ( Flutter )**

Flutter is a versatile open-source UI software development kit created
by Google, renowned for its capability to build natively compiled
applications for mobile, web, and desktop from a single codebase.
Launched in 2017, Flutter utilizes the Dart programming language and
offers a rich set of pre-designed widgets and tools that expedite the
development process while ensuring consistency and high performance
across platforms. Its reactive frame-work enables rapid prototyping and
seamless deployment, making it a preferred choice for developers aiming
to deliver visually appealing and responsive applications across diverse
operating systems. With a growing community and continuous updates
enhanc-ing its features, Flutter continues to redefine cross-platform
development by empowering developers to create stunning user experiences
efficiently

**5.1.2** **Web Frontend ( Flutter Web )**

Flutter Web extends the capabilities of the Flutter framework to enable
developers to

build full-featured, scalable web applications using the same codebase
as their mobile

apps. Introduced as a technical preview in 2019 and officially released
in 2020, Flutter

Web leverages the same reactive framework and widget system that Flutter
is known for,

allowing developers to create responsive, visually rich web applications
that can adapt

seamlessly across different screen sizes and devices. By compiling Dart
code to optimized

JavaScript, Flutter Web enables high performance and smooth animations,
while also

supporting features like hot reload for rapid iteration during
development. With its

growing ecosystem of plugins and libraries, Flutter Web empowers
developers to build

modern, engaging web experiences efficiently, bridging the gap between
mobile and web

platforms.

**5.1.3** **Backend ( NodeJS )**

Node.js is a powerful runtime environment built on Chrome's V8
JavaScript engine, designed for scalable and efficient server-side
applications. It allows developers to use JavaScript both for frontend
and backend development, unifying the programming lan-guage across the
entire stack. Express.js, often referred to simply as Express, is a
min-imalist and flexible web application framework for Node.js. It
provides a robust set of features for building web and mobile
applications, including middleware support for han-dling requests and
responses, routing mechanisms to define application endpoints, and a
template engine for rendering dynamic HTML content. Express simplifies
the process of building APIs and web servers, offering a lightweight and
fast solution that is highly ex-tensible through its ecosystem of
middleware and third-party modules. Together, Node.js and Express form a
potent combination for developing scalable and performant server-side
applications, making them popular choices among developers for building
modern web applications and APIs.



**5.1.4** **Database ( NoSQL MongoDB & Firebase )**

MongoDB is a NoSQL database that stores data in a flexible, JSON-like
format, making it particularly suitable for handling unstructured or
semi-structured data. It is known for its scalability, high performance,
and ease of use, especially in applications with large volumes of data
or where the schema may evolve over time. The Mongoose pack-age, on the
other hand, is an ODM (Object Data Modeling) library for MongoDB and
Node.js, providing a straightforward way to model application data and
interact with MongoDB databases using JavaScript objects. Mongoose
simplifies CRUD operations, schema validation, and relationships between
data, offering a schema-based solution on top of MongoDB's schema-less
nature.

> Our database schemas:

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image2.png)


> Our firebase for chatting system:

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image3.png)


**5.1.5** **API Testing & Documentation ( Postman )**

REST APIs Are introduced in the system, using different CRUD operations
and methods of HTTP LIKE (PUT,POST,Patch \...)\
Postman

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image4.png)



**5.1.6** **Web Application Features:**

Authentication MatjarCom prioritizes user security through a
dual-layered approach.

Utilizing JSON Web Tokens (JWT), the platform generates secure tokens
during user

authentication, ensuring verified access. database, enhancing data
protection

> User passwords are stored encrypted in the

Authorization Implement separate authorization logic in each endpoint to
validate user type (customer, merchant, admin) based on the JWT
payload.˙\
Ensure API security with CORS, HTTP headers, and rate-limiting
(express-rate-limit) to prevent abuse and protect against common
vulnerabilities.

**6** **User-Friendly Interface**

**6.1** **Splash Screen**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image5.png)

Figure 1: splash screen is an introductory screen that appears when an
application is launched.

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image6.png)
![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image7.png)
![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image8.png)


Figure 2: onboarding page (or series of pages) is designed to introduce
new users to an app or service. The goal is to guide users through
initial setup and demonstrate core features and benefits.

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image12.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image13.png)
    ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image14.png)



Figure 4: Login, register, and Forgot & Reset Password for Merchant



**6.4** **Merchant Side**

**6.4.1** **Login Page**

\* Robust login page, by put fields validators, display message in
dialog when merchant insert invalid email or password, display another
message in dialog when merchant try to login with large number with
wrong data this protect our system from dDOS attack which could hult
server.

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image15.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image16.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image17.png)


Figure 5: Robust merchant login page

**6.4.2** **Register Page**

\* Robust register page, by put fields validators, as phone number must
be consist of 10 digits & start with "05", password validator must
contain at least 8 characters , at least 1 number, at least 1 small
letter, at least 1 capital letter , at least 1 special character .


  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image18.png) 
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image19.png)  
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image20.png)


Figure 6: Robust merchant login page

**6.4.3** **Main Page & Personal Information**

\* After login or register successfully, redirect merchant to main page,
after that merchant could display & update his information, Enter to
store management and add payments information.

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image21.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image22.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image23.png)


Figure 7: Merchant main page & Merchant display & update information
data

16

**6.4.4** **Payment Information & Store Management**

\* Add payment information & Enter to store management page.

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image24.png) 
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image25.png)  
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image26.png)


Figure 8: Payment Information & Store Management

**6.4.5** **Design your store**

\* Merchant Enter to Edit your store design , this allow merchant to
Create & Design his store UI, add image on slider for advertisment,
delete images from image slider, allow merchant to create , update &
delete category, allow merchant to create product apply discount , put
the product in specific category, put quantities & price, update product
data also allow merchant to add images to product, allow merchant to
activate & de-activate slider, categories & products

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image27.png) 
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image28.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image29.png)


Figure 9: Edit store design, add image to slider, delete image from
slider, add, update and delete category


  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image30.png)
    ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image31.png)
       ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image32.png)


Figure 10: Create new Product

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image33.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image34.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image35.png)
  


Figure 11: Product added successfully, upload image for product,
activate store components

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image36.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image37.png)
    ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image34.png)
  



Figure 12: Preview activate & de-activate components

\* Select Store design page, this allow merchant to select background,
boxes , clipping , primary text, secondary text color,via color picker
window, allow merchant to customize components design by put them smooth
or solid, give the merchant 3 different design options , provide preview
button to allow merchant to preview his design before publish it,
provide another button which allow merchant to publish store , then the
store will published & user could interact with it.

 
 
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image38.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image39.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image40.png)
  



Figure 13: Select & customize your store design


> \* view all design options

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image41.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image42.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image43.png)
  



Figure 14: view all design options\
\* We note that error message displayed , it indicate that merchant
doesn't insert his payment information

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image44.png)


> Figure 15: Error message related to payment information \* We go to
> lahza.io, & add the keys for Trial version



![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image45.png)


![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image46.png)

Figure 16: add the keys for Trial version


\* we note that keys added successfully & store published successfully!
& Display store

informations

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image47.png)
> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image48.png)
![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image49.png)


Figure 17: publish store successfully & display store information

**6.4.6** **display & edit store information**

\* merchant doesn't add social media account link, display & edit store
information

  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image50.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image51.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image52.png)
  



Figure 18: merchant doesn't add social media account link, display &
edit store information


**6.4.7** **Social Media Accounts & Chat System**

> \* allow merchant add his social media accounts, also allow merchant
> to enter to chat system, it consist of 2 parts, part allow merchant to
> chat with his customer , another part allow merchant to chat with
> admin.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image53.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image54.png)
  ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image55.png)
  


Figure 19: add social media account & chat system

**6.4.8** **Chating pages & Custom Notifications**

\* Open chat page with specific customer, open chat page with admin,
also allow merchant to create

custom notification

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image56.png)

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image57.png)

>
> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image58.png)


Figure 20: add social media account & chat system



**6.4.9** **FAQ Page, delete store & Logout**\
\* FAQ ( Frequently Asked Questions ) page , delete store & logout

![Image 1](verto_pal_9b7a60fcace04364a/media/image59.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image60.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image61.png)



Figure 21: FAQ page , delete store & logout

**6.4.10** **Store Statistics Page**\
\* Store Statistics page

![Image 1](verto_pal_9b7a60fcace04364a/media/image62.png)
 ![Image 2](verto_pal_9b7a60fcace04364a/media/image63.png)
 ![Image 3](verto_pal_9b7a60fcace04364a/media/image64.png)
 


Figure 22: Store Statistics Page



**6.5** **Customer Side**

**6.5.1** **Customer Register Page, main page & Drawer**

\* Inside main page allow customer to browse different stores & Filter
stores depend on

their categories.

![Image 1](verto_pal_9b7a60fcace04364a/media/image65.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image66.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image67.png)


Figure 23: Customer Register Page, Main Page & Drawer



**6.5.2** **Display & Edit Customer Profile, Enter to Shopping cart and
favorite products**

\* allow customer to display & update his information , enter to cart,
inside cart allow user but products from different stores & the money
will redirect into each merchant card independently, also Favourite
products page allow customers put products inside favorite list from
different stores

![Image 1](verto_pal_9b7a60fcace04364a/media/image68.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image69.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image70.png)


Figure 24: Display & Edit Customer Profile, Enter to Shopping cart and
favorite products


**6.5.3** **Help & Support and specific store**

\* Help & Support allow customers to send email to admin, also enter to
specific store .

![Image 1](verto_pal_9b7a60fcace04364a/media/image71.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image72.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image73.png)



Figure 25: Help & Support and specific store


**6.5.4** **Favorite Products, Enter to specific product & add product
to cart successfully!**

\* Inside favorite product list allow customer to display all favorite
products & search box allow customer to search about specific product,
with modern search bar which filtered each inserted character, another
page for display product & enter quantity of product to buy

![Image 1](verto_pal_9b7a60fcace04364a/media/image74.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image75.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image76.png)



Figure 26: Favorite Products, Enter to specific product & add product to
cart successfully!


**6.5.5** **Shopping Cart**\
\* Now enter to shopping cart, for checkout the product add payment
informations & buy the product.

![Image 1](verto_pal_9b7a60fcace04364a/media/image77.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image78.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image79.png)


Figure 27: Shopping Cart


**6.5.6** **Rating & Reviews**\
\* Allow customer to review the product rate , & allow customer to rate
specific product & add his comment

![Image 1](verto_pal_9b7a60fcace04364a/media/image80.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image81.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image82.png)



Figure 28: Rating & Reviews



**6.5.7** **Notifications**\
\* Allow customer to turn on or turn off notification, when turn off the
customer doesn't receive any notification from this store merchant.

![Image 1](verto_pal_9b7a60fcace04364a/media/image83.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image84.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image85.png)



Figure 29: Notifications

**6.5.8** **Help & Support**

\* allow customers to send his questions to the merchant

![Image 1](verto_pal_9b7a60fcace04364a/media/image86.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image87.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image88.png)


Figure 30: Help & Support


**6.5.9** **Help & Support**

\* allow customers to send his questions to the merchant

![Image 1](verto_pal_9b7a60fcace04364a/media/image89.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image90.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image91.png)



Figure 31: Help & Support



**6.5.10** **Chatting Page**

\* allow customers chat with merchant

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image92.png)

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image93.png)


Figure 32: Chatting Page


**6.5.11** **Create a Custom Notification**

\* allow customers to create & send notification to his customers

![Image 1](verto_pal_9b7a60fcace04364a/media/image94.png)
![Image 2](verto_pal_9b7a60fcace04364a/media/image95.png)
![Image 3](verto_pal_9b7a60fcace04364a/media/image96.png)



Figure 33: Create a Custom Notification



**6.5.12** **Forgot & Reset Password**

> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image97.png)
> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image98.png)
> ![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image99.png)


Figure 34: Forgot & Reset Password

![Image 1](verto_pal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image100.png)
![Image 2](verto_pal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image101.png)
![Image 3](verto_pal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image102.png)
![Image 4](verto_pal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image103.png)



Figure 35: Forgot & Reset Password



**6.6** **Admin Dashboard Side**

**6.6.1** **Login Page**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image104.png)


Figure 36: Forgot & Reset Password


**6.6.2** **Login Page**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image104.png)


Figure 37: Login Page

**6.6.3** **Register Page**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image105.png)


Figure 38: Register Page



**6.6.4** **Forgot & Reset Password Page**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image106.png)


Figure 39: Forgot & Reset Password Page

**6.6.5** **Admin Dashboard**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image107.png)


Figure 40: Admin Dashboard



**6.6.6** **Add & Delete Category**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image108.png)


![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image109.png)


Figure 41: Add & Delete Category



**6.6.7** **Store & merchants Tables**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image110.png)

Figure 42: Store & merchants Tables

**6.6.8** **Tasks & Messages**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image111.png)

Figure 43: Tasks & Messages



**6.6.9** **Create new task**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image112.png)

Figure 44: Create new task

**6.6.10** **Delete Task**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image113.png)

Figure 45: Delete Task


**6.6.11** **Enter to chat with specific merchant**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image114.png)

Figure 46: Enter to chat with specific merchant

**6.6.12** **Delete Merchant or Store**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image115.png)

Figure 47: Delete Merchant or Store


**6.6.13** **Admin account**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image116.png)

Figure 48: Admin Account

**6.6.14** **Billing Information**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image117.png)

Figure 49: Billing Information


**6.6.15** **Admin account**

![](vertopal_9b7a60fcace04364a74e1bfbe9b7e53f/media/image118.png)

Figure 50: Admin Account

**7** **Result & Discussion**

MatjarCom has emerged as a robust and versatile multi-vendor platform,
demonstrating significant potential in streamlining and enhancing the
e-commerce experience for both merchants and customers. The application
effectively addresses the complexities involved in managing and
operating online stores while providing an intuitive and user-friendly
interface for end-users.

**8** **Conclusion**

MatjarCom successfully bridges the gap between merchants and customers
by providing a comprehensive multi-vendor platform that is both powerful
and accessible. The app's well-thought-out design and functionality
cater to the diverse needs of online store man-agement and customer
interaction. Merchants benefit from a wide range of customization and
management tools, while customers enjoy a seamless and enriched shopping
experi-ence.

The backend's focus on security, scalability, and performance, combined
with a dy-namic and responsive Flutter-based frontend, underscores the
app's capability to handle the demands of modern e-commerce. MatjarCom
sets a high standard for multi-vendor applications by integrating
advanced features, offering a bilingual interface, and ensuring secure
and efficient operations.

In conclusion, MatjarCom not only meets but exceeds the expectations of
a multi-vendor e-commerce solution, paving the way for future
enhancements and broader adop-tion in the digital marketplace. With
continuous updates and improvements, it is poised to become a leading
platform in the multi-vendor e-commerce sector.

