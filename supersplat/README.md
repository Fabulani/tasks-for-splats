# SuperSplat - 3D Gaussian Splat Editor

Website: [Supersplat](https://github.com/playcanvas/supersplat)

From their page:

> SuperSplat is a free and open source tool for inspecting, editing, optimizing and publishing 3D Gaussian Splats. It is built on web technologies and runs in the browser, so there's nothing to download or install.

## Dataset

The app accepts `.ply` files, ideally compressed for web rendering.

## Usage

Access the app on <http://localhost:3000>.

Recommended settings on Chrome:

- Enable `Force High Performance GPU`: `chrome://flags/#force-high-performance-gpu`.
- Open the Developer Tools panel and:
  - Visit the Network tab and check `Disable cache`.
  - Visit the Application tab, select `Service workers` on the left and then check `Update on reload` and `Bypass for network`.

---

For further details, see the [Supersplat User Guide](https://github.com/playcanvas/supersplat/wiki).
