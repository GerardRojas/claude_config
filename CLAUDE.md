# Working agreement — German / NGM (config personal, todas las máquinas)

Quien soy: fundador de NGM. Construimos **SaaS como producto + soluciones de software a medida para empresas**.
Plan: **Claude Max 20x**. Idioma de conversación: **español**. Código y texto visible al usuario final: **inglés**.

> Este archivo es mi config **personal** y aplica a TODAS mis sesiones en esta máquina.
> Lo específico de cada proyecto (stack, comandos, convenciones, deploy) vive en el `CLAUDE.md`
> de la raíz de cada repo (NGM_HUB, NGM_FastAPI) y se versiona con su código.

---

## Cómo quiero que trabajes

- **Máxima velocidad, yo reviso el resultado.** Modo por defecto `acceptEdits`. No me pidas permiso
  para editar archivos, correr builds/tests/linters, `git add`/`commit`, ni comandos de lectura. Actúa.
- **Pide confirmación SOLO para lo irreversible/externo** (ya forzado en settings → `ask`):
  `git push`, deploy, `npm publish`, y cualquier cosa destructiva en base de datos.
- Cuando tengas suficiente para actuar, **actúa**; no me listes opciones que no vas a tomar.
  Si dudas entre caminos, dame **una recomendación**, no un menú.
- Reporta fiel: si un test falla, dímelo con el output. No digas "listo" sin verificar.

## ⚠️ Regla global de seguridad
Varios de mis repos hacen **deploy a producción en `git push origin main`**. Nunca hago push a main
sin confirmarlo explícitamente. Antes de cualquier push: build + tests, diff resumido, y espera mi OK.

## Cómo sacarle jugo al Max 20x (sweet point multiagente)
Regla: **Opus piensa, Haiku/Explore leen, Sonnet implementa.** El límite real es la cuota semanal de
tokens, no el contexto (cada subagente está aislado).

- **Paralelismo:** 3–6 agentes para trabajo real; hasta 8–10 para reconocimiento de solo-lectura.
  Más allá, la síntesis se vuelve el cuello de botella y quemas cuota.
- **Tarea profunda (refactor/debug):** 1 hilo Opus + 2–3 `Explore` de apoyo que le traen contexto.
- **Tareas paralelas independientes:** fan-out de 4–6 implementadores Sonnet, aislados para que no se pisen.
- Para resultados grandes, que los agentes **escriban a archivos** en vez de devolver todo inline; `/compact` si el contexto principal se llena.

## Control remoto (móvil)
`claude --remote-control "NGM"` → escanear QR con la app de Claude (pestaña Code). Activar push en
`/config` ("Push when Claude decides" + "Push when actions required").
