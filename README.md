<p align="center">
  <img src="assets/branding/logo_el_mandadito.png" alt="Logo El Mandadito" width="150"/>
</p>

<h1 align="center">🛍️ El Mandadito App 🛍️</h1>

<p align="center">
  <i>Tu compañero ideal para compras rápidas y sencillas.</i>
</p>

---
## 🌟 Descripción General

"El Mandadito" es una aplicación móvil de comercio electrónico desarrollada con **Flutter**, diseñada para ofrecer una experiencia de compra **intuitiva y fluida**. Permite a los usuarios explorar una amplia gama de productos, gestionar su carrito de compras de manera eficiente, acceder a detalles completos de cada artículo y administrar su perfil personal con facilidad.

Este proyecto es parte de un esfuerzo académico/personal, con un enfoque en la construcción de una interfaz de usuario **moderna, limpia y funcional**, complementada con una gestión de estado robusta para la autenticación de usuarios y la manipulación de datos.

---

## ✨ Características Principales

Aquí te presentamos lo que puedes hacer con El Mandadito:

* ### **Inicio Dinámico (Home Screen)**
    * **Carrusel de Banners Animado:** Disfruta de nuestras promociones y ofertas destacadas que se desplazan automáticamente, manteniendo la experiencia fresca y atractiva.
        <p align="center">
          <img src="assets/screenshots/home_carousel.gif" alt="Captura de Pantalla: Carrusel de Banners en Home" width="350"/>
          <br>
          <i>Visualización del carrusel de imágenes automático en la pantalla de inicio.</i>
        </p>
    * **Categorías Organizadas:** Explora productos fácilmente por categorías como `Frutas`, `Verduras`, `Carnes`, `Lácteos`, `Bebidas` y más, accesibles a través de botones horizontales.
    * **Explorador de Productos:** Una cuadrícula interactiva de productos destacados, cada uno con su propia tarjeta informativa para una navegación rápida.
        <p align="center">
          <img src="assets/screenshots/home_products_grid.png" alt="Captura de Pantalla: Cuadrícula de Productos en Home" width="350"/>
          <br>
          <i>Vista de la cuadrícula de productos destacados con tarjetas reutilizables.</i>
        </p>

* ### **Detalles del Producto (Product Detail Screen)**
    * Sumérgete en la información de cada producto: visualiza sus imágenes, lee descripciones completas y consulta los precios.
    * **Añadir al Carrito:** Un botón dedicado siempre visible para agregar tus selecciones al carrito de forma instantánea.
        <p align="center">
          <img src="assets/screenshots/product_detail.png" alt="Captura de Pantalla: Detalle del Producto" width="300"/>
          <br>
          <i>Interfaz de la pantalla de detalle de un producto.</i>
        </p>

* ### **Tu Carrito de Compras (Cart Screen)**
    * Visualiza de manera clara y organizada todos los ítems que has añadido a tu carrito, incluyendo sus cantidades y precios (elementos de UI simulados para demostración).
    * **Gestión Fácil:** Elimina productos que ya no desees con un simple toque en el icono de papelera.
    * **Proceso de Compra:** Un botón prominente te permite iniciar el proceso de pago cuando estés listo para finalizar tu compra.
        <p align="center">
          <img src="assets/screenshots/cart_screen.png" alt="Captura de Pantalla: Carrito de Compras" width="300"/>
          <br>
          <i>Diseño de la pantalla del carrito con lista de ítems.</i>
        </p>

* ### **Experiencia de Usuario Personalizada (Profile & Auth)**
    * **Inicio de Sesión y Registro:** Un proceso guiado e intuitivo para acceder a tu cuenta existente o crear una nueva.
    * **Acceso Rápido:** Un modal amigable (`LoginPromptSheet`) te invita a iniciar sesión o registrarte si intentas acceder a secciones protegidas (Perfil, Carrito) sin autenticación.
    * **Gestión de Perfil (`ProfileScreen`):** Un centro personal donde puedes:
        * **Información Personal (`PersonalInfoScreen`):** Accede a un formulario para ver y actualizar tus datos de contacto, dirección y fecha de nacimiento.
            <p align="center">
              <img src="assets/screenshots/personal_info_screen.png" alt="Captura de Pantalla: Información Personal" width="300"/>
              <br>
              <i>Formulario para la gestión de información personal del usuario.</i>
            </p>
        * **Centro de Ayuda (`HelpCenterScreen`):** Envía tus consultas, sugerencias o reportes de problemas directamente desde la aplicación.
            <p align="center">
              <img src="assets/screenshots/help_center_screen.png" alt="Captura de Pantalla: Centro de Ayuda" width="300"/>
              <br>
              <i>Interfaz para enviar consultas en el Centro de Ayuda.</i>
            </p>
        * **Historial de Compras (`PurchaseHistoryScreen`):** Revisa un registro detallado de todas tus transacciones anteriores.
            <p align="center">
              <img src="assets/screenshots/purchase_history_screen.png" alt="Captura de Pantalla: Historial de Compras" width="300"/>
              <br>
              <i>Diseño de la pantalla de historial de compras.</i>
            </p>
        * **Cerrar Sesión:** Mantén tu cuenta segura cerrando tu sesión cuando lo necesites.
        <p align="center">
          <img src="assets/screenshots/profile_screen.png" alt="Captura de Pantalla: Mi Perfil" width="300"/>
          <br>
          <i>Vista general de la pantalla de perfil del usuario.</i>
        </p>
* **Navegación Intuitiva:**
    * Una `BottomNavigationBar` consistente para un cambio fluido entre las secciones principales: Inicio, Perfil y Carrito.
    * Botones de navegación de vuelta (`Icons.arrow_back`) estratégicamente ubicados en las pantallas secundarias para una experiencia de usuario sin fricciones.

---

## 🚀 Tecnologías y Herramientas

Este proyecto está construido sobre una base sólida de tecnologías modernas, siguiendo las mejores prácticas de desarrollo de Flutter:

* **Framework:** 💙 [**Flutter**](https://flutter.dev/) - Un UI toolkit de Google para construir aplicaciones compiladas nativamente para móvil, web y escritorio desde una única base de código.
* **Lenguaje:** 🎯 [**Dart**](https://dart.dev/) - El lenguaje de programación optimizado para el desarrollo de UI, diseñado para un rendimiento rápido en todas las plataformas.
* **Gestión de Estado:** 📦 [**Provider**](https://pub.dev/packages/provider) - Una envoltura simple pero potente alrededor de `InheritedWidget` de Flutter, utilizada para una gestión de estado reactiva y desacoplada (especialmente para la autenticación simulada).
* **Componentes UI Adicionales:**
    * [`cupertino_icons`](https://pub.dev/packages/cupertino_icons): Un conjunto de íconos de estilo iOS que complementan el diseño Material.
    * [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator): Un widget personalizable para indicar la página actual en un `PageView`.
* **Custom Graphics:** Implementación de `CustomPaint` para renderizar elementos de diseño únicos y atractivos en el encabezado de las pantallas de autenticación.

