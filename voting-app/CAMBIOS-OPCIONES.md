# 🍕 Configuración de Opciones Personalizadas

## ✅ Cambios Realizados

Ahora puedes cambiar "Cats vs Dogs" por cualquier opción (ej: "Pizza vs Tacos") usando variables de entorno.

### Archivos Modificados:

#### 1. `docker-compose.yml`
Añadidas variables de entorno a ambos servicios:

```yaml
services:
  vote:
    environment:
      - OPTION_A=Pizza
      - OPTION_B=Tacos
  
  result:
    environment:
      - OPTION_A=Pizza
      - OPTION_B=Tacos
```

#### 2. `result/server.js`
- Añadido soporte para leer `OPTION_A` y `OPTION_B` de variables de entorno
- Creado endpoint `/options` para que el frontend obtenga las opciones

```javascript
var option_a = process.env.OPTION_A || "Cats";
var option_b = process.env.OPTION_B || "Dogs";

app.get('/options', function (req, res) {
  res.json({
    option_a: option_a,
    option_b: option_b
  });
});
```

#### 3. `result/views/app.js`
- Modificado el controlador Angular para cargar opciones dinámicamente
- Añadido `$http.get('/options')` para obtener las opciones del servidor

```javascript
$scope.optionA = "Cats";
$scope.optionB = "Dogs";

$http.get('/options').then(function(response) {
  $scope.optionA = response.data.option_a;
  $scope.optionB = response.data.option_b;
});
```

#### 4. `result/views/index.html`
- Reemplazado texto hardcodeado por variables Angular
- Cambiado `<div class="label">Cats</div>` por `<div class="label">{{optionA}}</div>`
- Cambiado `<div class="label">Dogs</div>` por `<div class="label">{{optionB}}</div>`
- Título dinámico: `<title>{{optionA}} vs {{optionB}} -- Result</title>`

---

## 🚀 Cómo Usar

### Opción 1: Editar docker-compose.yml

```yaml
services:
  vote:
    environment:
      - OPTION_A=Cerveza
      - OPTION_B=Vino
  
  result:
    environment:
      - OPTION_A=Cerveza
      - OPTION_B=Vino
```

### Opción 2: Variables de entorno en CLI

```bash
OPTION_A="React" OPTION_B="Vue" docker compose up
```

### Opción 3: Archivo .env

Crea un archivo `.env` en la raíz:

```env
OPTION_A=Playa
OPTION_B=Montaña
```

Y modifica docker-compose.yml:

```yaml
services:
  vote:
    environment:
      - OPTION_A=${OPTION_A}
      - OPTION_B=${OPTION_B}
  
  result:
    environment:
      - OPTION_A=${OPTION_A}
      - OPTION_B=${OPTION_B}
```

---

## 🧪 Probar los Cambios

```bash
# 1. Reconstruir las imágenes
docker compose build

# 2. Levantar los servicios
docker compose up

# 3. Abrir en el navegador
# Votación: http://localhost:8080
# Resultados: http://localhost:8081
```

Deberías ver "Pizza vs Tacos" en ambas páginas.

---

## 📝 Valores por Defecto

Si no defines las variables, usa los valores originales:
- `OPTION_A` = "Cats"
- `OPTION_B` = "Dogs"

---

## 🎨 Ejemplos de Opciones

```yaml
# Comida
OPTION_A=Pizza
OPTION_B=Tacos

# Tecnología
OPTION_A=Docker
OPTION_B=Kubernetes

# Deportes
OPTION_A=Fútbol
OPTION_B=Baloncesto

# Lenguajes
OPTION_A=Python
OPTION_B=JavaScript

# Ciudades
OPTION_A=Madrid
OPTION_B=Barcelona
```

---

## ⚠️ Importante

**Ambos servicios (`vote` y `result`) deben tener las mismas variables** para que las opciones coincidan en ambas páginas.