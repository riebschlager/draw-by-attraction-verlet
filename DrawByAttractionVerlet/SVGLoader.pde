class SVGLoader {
  public SVGLoader() {
  }
  // Create an SVG with several shapes, each on its own layer.
  // Make sure they're all crammed into the top-left of the artboard.

  void loadVectors(ArrayList _shapeList, String _path, int _limit, String ... _folderName) {
    for (int i = 0; i < _folderName.length; i++) {
      int limit = 0;
      File folder = new File(_path + _folderName[i]);
      File[] listOfFiles = folder.listFiles();
      for (File file : listOfFiles) {
        if (file.isFile()) {
          PShape shape = loadShape(file.getAbsolutePath());
          for (PShape layer : shape.getChildren()) {
            if (layer!=null && limit < _limit) {
              layer.disableStyle();
              _shapeList.add(layer);
              limit++;
            }
          }
        }
      }
    }
  }
}

