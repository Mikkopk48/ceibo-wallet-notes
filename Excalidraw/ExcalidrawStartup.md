/*
Script de inicio de Excalidraw (Settings > Excalidraw > Startup script).
- PNG exportados automáticamente -> pngs-generados/<nombre del dibujo>.png
- Imágenes pegadas dentro de un dibujo -> assets/
*/
ea.onImageExportPathHook = (data) => {
  const name = data.excalidrawFile.basename.replace(/\.excalidraw$/, "");
  return `pngs-generados/${name}${data.exportExtension}`;
};
ea.onImageFilePathHook = (data) => `assets/${data.currentImageName}`;
