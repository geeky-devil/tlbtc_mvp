import { defineConfig } from 'vite';
import compression from 'vite-plugin-compression';

export default defineConfig({
  plugins: [
    // Gzip compression
    compression({
      algorithm: 'gzip',           // Use gzip compression
      ext: '.gz',                  // Append .gz to compressed files
      deleteOriginFile: false,     // Do not delete original files
      threshold: 0,                // Compress all files, even small ones
      include: [                   // Compress specific files
        /\.(js|css|html|wasm|pck|json|ico|svg|png|jpg|jpeg|gif|webp)$/i,
      ],
    }),
    // Brotli compression (optional)
    compression({
      algorithm: 'brotliCompress', // Use Brotli compression
      ext: '.br',                  // Append .br to compressed files
      deleteOriginFile: false,
      threshold: 0,
      include: [
        /\.(js|css|html|wasm|pck|json|ico|svg|png|jpg|jpeg|gif|webp)$/i,
      ],
    }),
  ],
  build: {
    outDir: 'dist', // Final output folder for deployment
    rollupOptions: {
      // Ensure public files (including Godot exports) are copied to dist/
      input: {
        main: './public/godot-export/index.html', // Godot export entry
      },
    },
  },
});
