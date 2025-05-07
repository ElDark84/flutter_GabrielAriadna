# 🎬 casopractica_gabrielariadna

Aplicación Flutter desarrollada como caso práctico por Ariadna Gabriel.  
Permite explorar películas, series y reseñas con una interfaz moderna, navegación intuitiva y gestos táctiles personalizados.

---

## 🚀 Funcionalidades

- 🔍 Búsqueda en tiempo real.
- 🎞️ Visualización de películas y series con carátulas.
- 📝 Listado de reseñas en scroll horizontal.
- ⭐ Valoración por estrellas.
- 📄 Pantalla de detalle completa por ítem.
- 📱 Interfaz responsive con soporte para:
  - Tap para abrir detalle.
  - Doble tap para recargar contenido.
  - Long press para mostrar detalles rápidos.
  - Ocultado automático del teclado al tocar fuera.

---

## 🧱 Estructura del proyecto

```plaintext
lib/
├── controllers/       # ViewModels con lógica de negocio
├── models/            # Clases de datos como Movie
├── views/             # Pantallas principales y de detalle
├── widgets/           # Componentes reutilizables (cards, chips, etc.)
└── main.dart          # Punto de entrada de la app
🛠️ Tecnologías y paquetes utilizados
Flutter

provider - Gestión de estado

flutter_spinkit - Indicadores de carga animados

http - (opcional) para consumir APIs REST

Material 3 - Estilo visual moderno
