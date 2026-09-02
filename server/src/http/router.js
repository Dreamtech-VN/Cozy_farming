/**
 * Router tối giản có path param (doc 15 — versioned routes).
 * Pattern dạng '/v1/matches/:id/actions'.
 */
export function createRouter() {
  const routes = [];

  const compile = (pattern) => {
    const names = [];
    const source = pattern
      .split('/')
      .map((segment) => {
        if (!segment.startsWith(':')) return segment.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        names.push(segment.slice(1));
        return '([^/]+)';
      })
      .join('/');
    return { regex: new RegExp(`^${source}$`), names };
  };

  const add = (method, pattern, handler, options = {}) => {
    const { regex, names } = compile(pattern);
    routes.push({ method, pattern, regex, names, handler, ...options });
  };

  return {
    get: (p, h, o) => add('GET', p, h, o),
    post: (p, h, o) => add('POST', p, h, o),
    patch: (p, h, o) => add('PATCH', p, h, o),
    delete: (p, h, o) => add('DELETE', p, h, o),

    /** Trả về { handler, params, auth } hoặc null; allowedMethods dùng cho 405. */
    match(method, pathname) {
      const allowed = new Set();
      for (const route of routes) {
        const found = route.regex.exec(pathname);
        if (!found) continue;
        allowed.add(route.method);
        if (route.method !== method) continue;
        const params = {};
        route.names.forEach((name, index) => { params[name] = decodeURIComponent(found[index + 1]); });
        return { route, params };
      }
      return allowed.size > 0 ? { allowedMethods: [...allowed] } : null;
    },

    get routes() { return routes.map((r) => `${r.method} ${r.pattern}`); },
  };
}
