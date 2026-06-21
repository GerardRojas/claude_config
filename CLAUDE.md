# Estándares NGM — German (config personal, todas las máquinas)

Quien soy: fundador de NGM. Construimos **SaaS como producto + soluciones de software a medida para empresas**.
Plan: **Claude Max 20x**. Idioma de conversación: **español**. Código y texto visible al usuario final: **inglés**.

> Este archivo define mi **forma de trabajar + estándares para TODOS mis proyectos**. Se versiona en
> el repo `claude_config` y se sincroniza en cada computadora. Lo específico de cada proyecto (stack,
> comandos, convenciones) vive en el `CLAUDE.md` de la raíz de ese repo. Los dos se cargan juntos y se suman.

---

## 1. Cómo quiero que trabajes
- **Máxima velocidad, yo reviso el resultado.** Modo `acceptEdits`. No pidas permiso para editar archivos,
  builds, tests, linters, `git add`/`commit`, ni comandos de lectura. Actúa.
- **Pide confirmación SOLO para lo irreversible/externo** (forzado en settings → `ask`): `git push`, deploy,
  `npm publish`, destructivo en base de datos.
- Cuando tengas suficiente para actuar, **actúa**; no listes opciones que no vas a tomar. Si dudas entre
  caminos, da **una recomendación**, no un menú.
- **Reporta fiel:** si un test falla, dímelo con el output. Si saltaste un paso, dilo. No digas "listo" sin verificar.

## 2. Seguridad de secretos (regla dura, todos los proyectos)
- **NUNCA** commitear secretos (API keys, service_role keys, passwords, tokens, connection strings).
- Secretos viven **solo** en `.env` (gitignored) o en las env vars del host (Render). En docs/markdown/scripts,
  **siempre placeholders** (`<TU-API-KEY-AQUI>`), nunca el valor real.
- Antes del primer commit de un repo, verificar que `.gitignore` incluya `.env*`.
- **Si detectas un secreto en código, repo o historial: DETENTE y avísame de inmediato** — no lo ignores ni
  lo dejes pasar. Un secreto pusheado debe ROTARSE (borrarlo no basta).
- Nada de secretos en `C:\tmp` ni en scripts sueltos; si un comando necesita un token, pásalo por env var efímera.

## 3. Git & commits (todos los proyectos)
- **Conventional commits:** `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `style:`, `test:`.
- Cerrar el mensaje con: `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`.
- **`git push origin main` suele desplegar PRODUCCIÓN** en mis repos (Render). Nunca push sin confirmación explícita.
- Prohibido sin mi OK: `git push --force`, `git reset --hard`, `git clean -fd`, reescritura de historial.

## 4. Verificación antes de push (no hay staging → la red de seguridad es local)
- **Frontend:** `npm run build` (o `tsc -b` + `vite build`) debe pasar.
- **Backend:** `py -m py_compile` / import de los archivos tocados + smoke local antes del push.
- **Migraciones SQL primero:** correr el `.sql` en la DB de prod ANTES (o junto) al deploy que lo consume,
  o los endpoints nuevos tiran 500. Hacerlas idempotentes.
- Cambios cara-al-cliente o refactors grandes → avisar/coordinar (la rama es producción en vivo).

## 5. Estándares de código
- Texto visible al usuario final en **inglés**; conversación conmigo en español.
- **Consistencia primero:** imita el estilo, naming y patrones del código que ya existe en ese repo.
- No dejar código muerto, comentado o `console.log` de debug.
- Reusar utilidades existentes antes de crear nuevas; preferir lo simple.

## 6. Sweet point multiagente (Max 20x)
Regla: **Opus piensa, Haiku/Explore leen, Sonnet implementa.** El límite real es la cuota semanal de tokens,
no el contexto (cada subagente está aislado).
- **Paralelismo:** 3–6 agentes para trabajo real; hasta 8–10 para reconocimiento de solo-lectura.
- **Tarea profunda (refactor/debug):** 1 hilo Opus + 2–3 `Explore` que le traen contexto.
- **Tareas paralelas independientes:** fan-out de 4–6 implementadores Sonnet, aislados.
- Resultados grandes → que los agentes escriban a archivos en vez de inline; `/compact` si el contexto principal se llena.

## 7. Organización de la config
- **Global (este archivo):** forma de trabajar + estándares + sweet point. Repo `claude_config`.
- **Por proyecto:** `CLAUDE.md` en la raíz de cada repo con stack, comandos exactos, convenciones y deploy.
- **Personal/secretos por máquina:** `settings.local.json` y `.env` → SIEMPRE gitignored, nunca en repos compartidos.

## 8. Control remoto (móvil)
`claude --remote-control "NGM"` → escanear QR con la app de Claude (pestaña Code). Activar push en `/config`
("Push when Claude decides" + "Push when actions required").
