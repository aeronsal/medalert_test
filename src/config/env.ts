/**
 * Client-side environment configuration.
 * Reads public variables exposed by Vite via `import.meta.env`.
 * Only variables with the `VITE_` prefix are accessible in the browser.
 */
export const clientEnv = {
  appName: import.meta.env.VITE_APP_NAME ?? 'MedAlert',
  apiBaseUrl: import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:5001/api',
  appEnv: import.meta.env.VITE_APP_ENV ?? 'development',
  isDev: import.meta.env.DEV,
  isProd: import.meta.env.PROD,
} as const;
