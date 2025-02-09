const esbuild = require('esbuild');
const http = require('http');

const clients = [];
const port = 8082;

const buildOptions = {
  entryPoints: ['app/javascript/application.tsx'],
  bundle: true,
  outdir: 'app/assets/builds',
  sourcemap: true,
  format: 'esm',
  publicPath: '/assets',
  loader: {
    '.tsx': 'tsx',
    '.ts': 'tsx',
    '.js': 'jsx',
    '.jsx': 'jsx',
  },
  define: {
    'process.env.NODE_ENV': '"development"',
  },
  plugins: [{
    name: 'live-reload',
    setup(build) {
      build.onEnd((result) => {
        if (result.errors.length > 0) return;
        clients.forEach((res) => res.write('data: update\n\n'));
      });
    },
  }],
};

async function startServer() {
  // Start esbuild context for watching
  const ctx = await esbuild.context(buildOptions);
  await ctx.watch();
  console.log('⚡ Build complete! Watching for changes... ⚡');

  // Start SSE server for live reload
  http.createServer((req, res) => {
    if (req.url === '/esbuild') {
      return clients.push(
        res.writeHead(200, {
          'Content-Type': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Access-Control-Allow-Origin': '*',
          Connection: 'keep-alive',
        })
      );
    }

    res.statusCode = 404;
    res.end();
  }).listen(port);

  console.log(`⚡ Live reload server running on port ${port} ⚡`);
}

startServer().catch((err) => {
  console.error('Error starting server:', err);
  process.exit(1);
}); 