---
marp: true
theme: default
paginate: true
backgroundColor: #ffffff
style: |
  section {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #112033;
    padding: 56px 64px;
    line-height: 1.35;
    background:
      radial-gradient(circle at 92% 10%, #dff3ff 0 18%, transparent 18%),
      radial-gradient(circle at 8% 95%, #ecf9f2 0 16%, transparent 16%),
      #f8fbff;
  }
  h1 {
    color: #0a3f6e;
    font-size: 52px;
    margin-bottom: 8px;
  }
  h2 {
    color: #0d4d80;
    font-size: 30px;
    margin-top: 0;
  }
  p, li {
    font-size: 24px;
  }
  ul {
    margin-top: 12px;
  }
  strong {
    color: #093e6a;
  }
  code {
    font-family: Consolas, 'Courier New', monospace;
    font-size: 18px;
    background: #dcecff;
    color: #052f54;
    padding: 2px 7px;
    border-radius: 6px;
  }
  pre {
    margin-top: 14px;
    border-radius: 14px;
    background: #0b1624;
    color: #f4f7fb;
    padding: 16px 18px;
    border: 1px solid #27415b;
    box-shadow: 0 12px 28px rgba(10, 32, 58, 0.2);
    overflow-x: auto;
  }
  pre code {
    background: transparent;
    color: #f4f7fb;
    font-size: 18px;
    padding: 0;
    line-height: 1.5;
  }
  pre code span,
  pre code .hljs,
  pre code .hljs-comment,
  pre code .hljs-quote,
  pre code .hljs-keyword,
  pre code .hljs-selector-tag,
  pre code .hljs-section,
  pre code .hljs-title,
  pre code .hljs-name,
  pre code .hljs-built_in,
  pre code .hljs-literal,
  pre code .hljs-string,
  pre code .hljs-number,
  pre code .hljs-operator,
  pre code .hljs-punctuation,
  pre code .hljs-attribute,
  pre code .hljs-symbol,
  pre code .hljs-bullet {
    color: #f4f7fb;
  }
  pre code .hljs-comment,
  pre code .hljs-quote {
    color: #93a4b8;
    font-style: italic;
  }
  pre code .hljs-keyword,
  pre code .hljs-selector-tag,
  pre code .hljs-section,
  pre code .hljs-title,
  pre code .hljs-name {
    color: #8cd6ff;
  }
  pre code .hljs-string,
  pre code .hljs-attribute,
  pre code .hljs-literal,
  pre code .hljs-number {
    color: #ffd479;
  }
  pre code .hljs-built_in,
  pre code .hljs-symbol,
  pre code .hljs-operator,
  pre code .hljs-punctuation,
  pre code .hljs-bullet {
    color: #c8d4e0;
  }
  .cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 26px;
    margin-top: 14px;
  }
  .card {
    background: #ffffff;
    border-radius: 14px;
    padding: 18px;
    box-shadow: 0 10px 24px rgba(25, 76, 120, 0.15);
    border-left: 7px solid #2383d1;
  }
  .bad {
    border-left-color: #d34848;
  }
  .good {
    border-left-color: #1d9b57;
  }
  .tiny {
    font-size: 20px;
    color: #1b3248;
  }
  .flow {
    background: #ffffff;
    border: 2px solid #cbe5f8;
    border-radius: 14px;
    padding: 12px 16px;
    font-size: 23px;
    margin-top: 16px;
  }
  .accent {
    color: #0a3f6e;
    font-weight: 700;
  }
  .footer-note {
    font-size: 18px;
    color: #21384e;
    margin-top: 10px;
  }
  .subtitle {
    font-size: 24px;
    color: #173e61;
  }
---

# Sesión 1: Contenerización con Docker

## De 0 a entorno local reproducible

<p class="subtitle"><strong>Objetivo:</strong> estandarizar el desarrollo y despliegue de aplicaciones</p>

![bg right:36% 85%](CartelCursoDevopsCloud.png)

---

# Aislamiento vs. Virtualización Tradicional

<div class="cols">
  <div class="card bad">
    <h2>Virtualización (VM)</h2>
    <ul>
      <li>SO completo por instancia</li>
      <li>Arranque más lento</li>
      <li>Mayor consumo de RAM/CPU</li>
    </ul>
  </div>
  <div class="card good">
    <h2>Contenedores (Docker)</h2>
    <ul>
      <li>Kernel compartido</li>
      <li>Inicio en segundos</li>
      <li>Portables y ligeros</li>
    </ul>
  </div>
</div>

<p class="footer-note"><span class="accent">Idea clave:</span> Docker empaqueta aplicación + dependencias, no un sistema operativo completo.</p>

---

# Caso Real: COMPÁS VIRTUAL se cae

<div class="cols">
  <div class="card bad">
    <h2>⚠️ Crisis sin Docker</h2>
    <ul class="tiny">
      <li>Página caída 🔴</li>
      <li>SSH a servidor</li>
      <li>Revisar logs, configs</li>
      <li>¿Qué versión de Node?</li>
      <li>¿Qué commit del código?</li>
      <li>30 min sin servicio 📉</li>
    </ul>
  </div>
  <div class="card good">
    <h2>✅ Respuesta con Docker</h2>
    <ul class="tiny">
      <li>Página caída 🔴</li>
      <li><code>docker run compas-virtual</code></li>
      <li>✅ Instancia 2 levantada</li>
      <li>Servicio restaurado (5s)</li>
      <li>O replicar en 3 servidores</li>
      <li>Load balancer distribuye</li>
    </ul>
  </div>
</div>

<p class="footer-note"><strong>La imagen es tu backup vivo:</strong> instancia múltiples contenedores cuando sea necesario.</p>

---

# Imagen vs. Contenedor

<div class="cols">
  <div class="card">
    <h2>🖼️ Imagen</h2>
    <ul class="tiny">
      <li><strong>Plantilla</strong> estática inmutable</li>
      <li>Capas comprimidas en un archivo</li>
      <li>Se construye una vez</li>
      <li><code>docker build</code></li>
      <li>Se descarga de Registry</li>
    </ul>
  </div>
  <div class="card">
    <h2>📦 Contenedor</h2>
    <ul class="tiny">
      <li><strong>Instancia</strong> ejecutable viva</li>
      <li>Copia de lectura-escritura de la imagen</li>
      <li>Múltiples contenedores de la misma imagen</li>
      <li><code>docker run</code></li>
      <li>Procesos en ejecución</li>
    </ul>
  </div>
</div>

<div class="flow">
<strong>Analógía:</strong> Imagen = <span class="accent">Clase</span> / Contenedor = <span class="accent">Instancia</span> de esa clase
</div>

<p class="footer-note">Una imagen puede generar <strong>N contenedores simultáneos</strong>, cada uno con su estado aislado.</p>

---

# Arquitectura de Docker

<div class="flow">
  <strong>CLI</strong> (<code>docker ...</code>)
  <span class="accent"> -> </span>
  <strong>Docker Engine API</strong>
  <span class="accent"> -> </span>
  <strong>Docker Daemon</strong>
  <span class="accent"> -> </span>
  <strong>Containers / Images / Volumes / Networks</strong>
</div>

<div class="flow">
  <strong>Daemon</strong>
  <span class="accent"> <-> </span>
  <strong>Registry</strong> (<code>Docker Hub</code>) para <code>pull</code> y <code>push</code>
</div>

<p class="footer-note">Piensa en Docker como una <strong>fabrica + gestor</strong> de entornos aislados.</p>

---

# Dominio de la CLI y Docker Desktop

<div class="cols">
  <div class="card">
    <h2>CLI minima que debes dominar</h2>
    <ul class="tiny">
      <li><code>docker run</code> crea y arranca</li>
      <li><code>docker ps</code> inspecciona estado</li>
      <li><code>docker exec</code> entra al contenedor</li>
      <li><code>docker logs</code> depura rapido</li>
    </ul>
  </div>
  <div>

```bash
docker run -d --name web -p 8080:80 nginx:alpine
docker ps
docker logs web
docker exec -it web sh
```

  </div>
</div>

<p class="footer-note">Docker Desktop te da visibilidad visual; la CLI te da <strong>velocidad y control</strong>.</p>

---

# Dockerfile desde cero

<p class="tiny">Un Dockerfile es una receta reproducible. Cada instrucción crea una capa.</p>

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["node", "server.js"]
```

<p class="footer-note"><strong>Regla:</strong> primero dependencias, luego codigo. Asi aprovechas cache y compila mas rapido.</p>

---

# Buenas Prácticas en Dockerfiles

<div class="cols">
  <div class="card bad">
    <h2>Evitar</h2>
    <ul class="tiny">
      <li><code>FROM node:latest</code></li>
      <li>Copiar todo sin <code>.dockerignore</code></li>
      <li>Ejecutar como root por defecto</li>
    </ul>
  </div>
  <div class="card good">
    <h2>Aplicar</h2>
    <ul class="tiny">
      <li><code>FROM node:20-alpine</code></li>
      <li>Multi-stage build</li>
      <li>Usuario no root + imagen minima</li>
    </ul>
  </div>
</div>

```dockerfile
# stage final segura
RUN addgroup -S app && adduser -S app -G app
USER app
```

---

# Docker Compose: Orquestacion local

<div class="flow">
  <strong>web</strong>
  <span class="accent"> <-> </span>
  <strong>db</strong>
  <span class="accent"> <-> </span>
  <strong>redis</strong>
  <span class="accent"> (misma red interna)</span>
</div>

```yaml
services:
  web: { build: ., ports: ["3000:3000"], depends_on: [db] }
  db: { image: postgres:16, environment: [POSTGRES_PASSWORD=dev] }
  redis: { image: redis:7-alpine }
```

<p class="footer-note">Con <code>docker compose up -d</code> levantas todo el entorno en un solo comando.</p>

---

# Workshop practico: Dockerizacion real

<div class="cols">
  <div class="card">
    <h2>Ruta de trabajo</h2>
    <ul class="tiny">
      <li>1. Build de imagen</li>
      <li>2. Compose con app + DB</li>
      <li>3. Volumen para persistencia</li>
      <li>4. Smoke test de conectividad</li>
    </ul>
  </div>
  <div>

```bash
git clone <repo>
docker compose build
docker compose up -d
docker compose ps
curl http://localhost:3000/health
```

  </div>
</div>

<p class="footer-note"><strong>Resultado esperado:</strong> entorno reproducible, persistente y listo para desarrollo.</p>

---

# Cierre de la sesión

## Lo que ya puedes hacer hoy

- Empaquetar una app en imagen Docker.
- Levantar un stack local con Compose.
- Aplicar buenas practicas desde el primer dia.

![bg right:36% 85%](CartelCursoDevopsCloud.png)
