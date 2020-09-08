class Network {
  int nodeNum ;
  int sourceIndex ;
  int sinkIndex ;
  int[][] edges ;
  int[][][] outGoing ;
  int[][][] inComing ;
  long[] edgesBit ;
  long[][] fanBit ;
  Network(String filename) {
    String[] lines = loadStrings(filename) ;
    int[] data = int(split(lines[0], ",")) ;
    nodeNum = data[0] ;
    sourceIndex = data[1] ;
    sinkIndex = data[2] ;
    setEdges(lines) ;
    //println() ;
  }
  void setEdges(String[] lines) {
    edges = new int[lines.length - 1][] ;
    for (int i = 0 ; i < edges.length ; i++) {
      edges[i] = splice(int(split(lines[i + 1], ',')), i, 0) ;
      edges[i][4] += edges[i][3] ;
    }
  }
  String toString() {
    String stg = "0" ;
    for (int i = 1 ; i < nodeNum ; i++) {
      stg += ", " + i ;
    }
    stg = "{ " + stg + " }\n" ;
    for (int i = 0 ; i < edges.length ; i++) {
      int[] e = edges[i] ;
      stg += "[" + e[0] + "](" + e[1] + ", " + e[2] + ", " + e[3] + ", " + e[4] + ", " + e[5] + ")\n" ;
    }
    return stg ;
  }
}
