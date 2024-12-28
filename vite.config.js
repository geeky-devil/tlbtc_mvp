import { defineConfig } from 'vite';
import compression from 'vite-plugin-compression';
import { viteStaticCopy } from 'vite-plugin-static-copy';

export default defineConfig({
  publicDir: false, // Disable default copying from public/
  plugins: [
    // Gzip compression
    compression({
      algorithm: 'gzip',           // Use gzip compression
      ext: '.gz',                  // Append .gz to compressed files
      deleteOriginFile: false,     // Do not delete original files
      threshold: 1048576,                // Compress all files, even small ones
      include: [                   // Compress specific files
        /\.(js|css|html|wasm|pck|json|ico|svg|png|jpg|jpeg|gif|webp)$/i,
      ],
    }),
    // Brotli compression (optional)
    //compression({
    //  algorithm: 'brotliCompress', // Use Brotli compression
    //  ext: '.br',                  // Append .br to compressed files
    //  deleteOriginFile: false,
    //  threshold: 1048576,
    //  include: [
    //    /\.(js|css|html|wasm|pck|json|ico|svg|png|jpg|jpeg|gif|webp)$/i,
    //  ],
    //}),
    viteStaticCopy({
        targets: [
          // Copy everything from godot-export/ to dist/
          {
            src: 'godot-export/**/*',
            dest: '',
          },
          // Copy everything from src/ to dist/
          {
            src: 'src/**/*',
            dest: '',
          },
        ],
      }),
  ],
  build: {
    outDir: 'dist', // Final output folder for deployment
    rollupOptions: {
        input: 'index.html', // Make sure this file exists!
      }
  },
});
