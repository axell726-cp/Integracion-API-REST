# Flutter CRUD Productos

Una aplicación Flutter que consume una API REST desarrollada en Spring Boot para gestionar productos (crear, listar, editar y eliminar). Se emplea Provider para manejar estado de forma centralizada, manteniendo la lógica separada de la interfaz y permitiendo una arquitectura escalable.

## 🎨 Características

- **CRUD completo**: Crear, leer, actualizar y eliminar productos.
- **Consumo de API REST** usando `http`.
- **Provider** para manejo de estado global y reactivo.
- **Validaciones** de formularios (nombre y precio).
- **UI simple y funcional**.
- **Actualización dinámica** de la lista de productos sin recargar la app.
---
## 📁 Estructura del Proyecto

```
lib/
├── main.dart                        # Punto de entrada de la aplicación
├── models/
│   └── product.dart                 # Modelo de datos del producto
├── services/
│   └── product_service.dart         # Consumo de API REST
├── providers/
│   └── product_provider.dart        # Manejo de estado con Provider
├── screens/
│   ├── product_list_page.dart       # Lista de productos
│   └── product_form_page.dart       # Formulario para crear/editar productos
└── widgets/
    └── (componentes opcionales)
```

---
## API REST Utilizada

Se consume una API Spring Boot con los siguientes endpoints:

| Método | Endpoint              | Acción                      |
| ------ | --------------------- | --------------------------- |
| GET    | `/api/productos`      | Obtener todos los productos |
| POST   | `/api/productos`      | Crear nuevo producto        |
| PUT    | `/api/productos/{id}` | Actualizar producto         |
| DELETE | `/api/productos/{id}` | Eliminar producto           |

---

## 🔧 **Configuración de Flutter (`product_service.dart`)**

### **Tu configuración actual:**
```dart
const String host = '10.0.2.2'; // Para emulador Android
```
Si usas dispositivo físico → reemplazar por la IP local, ej.: 192.168.1.100.
---

## 🛠️ **Instalación y Ejecución**

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/axell726-cp/Integracion-API-REST.git
   cd Integracion-API-REST
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```
## **Flujo de Uso**

1. **La app carga la lista de productos desde la API.**:

2. **Para agregar uno nuevo, usar el botón flotante (+).**:
   
3. **Tocar un producto para editarlo.**:

4. **Usar el menú contextual para eliminarlo.**:

## 👨‍💻 Autor

Axell Cardenas 
