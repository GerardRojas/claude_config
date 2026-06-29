---
description: Cierre pre-push NGM — code-review + security-review + verify + checklists §3/§4
---

Ejecuta el **flujo de cierre NGM** sobre el diff actual, en este orden. No declares "listo" hasta terminar los 5 pasos y reportar fiel (output real, no "debería pasar").

Contexto: `$ARGUMENTS` (opcional — qué cambió o a qué prestar atención).

## 1. Build / compile (red de seguridad local — §6)
- Frontend: `npm run build` (o `tsc -b` + `vite build`).
- Backend: `py -m py_compile` de los archivos tocados + import/smoke local.
- Si falla, **detente y repórtalo con el output**. No sigas al paso 2.

## 2. Revisión de código (local)
- Invoca `/code-review high` sobre el diff.
- Resume los hallazgos reales; aplica los `--fix` triviales y deja en mi mano los que cambien comportamiento.

## 3. Revisión de seguridad
- Invoca `/security-review` sobre los cambios pendientes.
- Cruza con el checklist §3: auth en cada endpoint, input validado del lado servidor, least privilege, **scoping multi-tenant por company_id**, cero secretos en código (si hay uno → DETENTE, hay que rotarlo).

## 4. Checklist de escalabilidad (§4)
- Prueba mental 10x/100x: índices, paginación, N+1, trabajo pesado en background, idempotencia de migraciones/webhooks.
- Si algo no aguanta, dilo y propón el diseño que sí.

## 5. Verificación funcional
- Si el cambio es ejecutable, invoca `/verify` (o `/run`) y observa el comportamiento real.
- Si hay migración SQL: recuérdame correrla en prod **antes/junto** al deploy (§6), idempotente.

## Cierre
- Entrega un resumen corto: ✅/⚠️ por paso, hallazgos abiertos y mi decisión pendiente.
- **Recordatorio:** para un push cara-al-cliente o refactor grande, dispara tú `/code-review ultra` (nube, facturado — yo no puedo lanzarlo) antes del `git push`. El push a `main` = **producción** (§5).
