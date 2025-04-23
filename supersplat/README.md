# SuperSplat - 3D Gaussian Splat Editor

Website: [Supersplat](https://github.com/playcanvas/supersplat)

From their page:

> SuperSplat is a free and open source tool for inspecting, editing, optimizing and publishing 3D Gaussian Splats. It is built on web technologies and runs in the browser, so there's nothing to download or install.

## Dataset

SuperSplat supports the importing of Gaussian Splat scenes in `.ply`, `.compressed.ply` and `.splat` format.

Note that only `.ply` files that contain 3D Gaussian Splat data can be imported. If you attempt to load any other type of data from a `.ply` file, it will fail.

Official docs: [Importing 3DGS Scenes into your Projects](https://github.com/playcanvas/supersplat/wiki/Importing-3DGS-Scenes-into-your-Projects) for more details.

## Usage

Access the app on <http://localhost:3000>.

Recommended settings on Chrome:

- Enable `Force High Performance GPU`: `chrome://flags/#force-high-performance-gpu`.
- Open the Developer Tools panel and:
  - Visit the Network tab and check `Disable cache`.
  - Visit the Application tab, select `Service workers` on the left and then check `Update on reload` and `Bypass for network`.

### Importing

Drag and drop your files, or use the `File` > `Import` menu to load your 3DGS model.

You can also [import a project file](https://github.com/playcanvas/supersplat/wiki/Saving-and-Loading-your-Projects) (`.ssproject`).

### Exporting

To export the currently loaded scene, open the `Scene` > `Export` submenu:

- PLY (`.ply`): uncompressed, heavyweight, most common format.
- Compresset PLY (`.compressed.ply`): compressed, WebGL compatible, lightweight.
- Splat File (`.splat`): also compressed, but not as efficient as Compressed PLY.
- HTML Viewer (`.html`/`.zip`): quick and easy way to publish and share splats

You can also [export a project file](https://github.com/playcanvas/supersplat/wiki/Saving-and-Loading-your-Projects) (`.ssproject`).

Official docs: [Exporting 3DGS Scenes from your Projects](https://github.com/playcanvas/supersplat/wiki/Exporting-3DGS-Scenes-from-your-Projects).

---

For further details, see the [Supersplat User Guide](https://github.com/playcanvas/supersplat/wiki).
