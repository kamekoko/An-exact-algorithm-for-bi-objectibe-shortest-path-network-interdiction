final int INDEX = 0 ;
final int TAIL = 1 ;
final int HEAD = 2 ;
final int ALPHA = 3 ;
final int BETA = 4 ;
final int COST = 5 ;

final int IN = 0 ;
final int OUT = 1 ;

class BranchAndBound {
  // NodeInfo
  int nodeNum ;
  int sinkIndex ;
  int[] nodeIndices ;
  int[] distances ;
  boolean[] free ;

  // EdgeInfo
  int edgeNum ;
  int[][][] outGoing ;
  int[][][] inComing ;
  int[] outGoingNum ;
  int[] inComingNum ;
  long[] edgesBit ;
  long[] fanBit ;


  SolutionSet ps ;
  BranchAndBound(Network net) {
    setNodeInfo(net) ;
    setEdgeInfo(net) ;
  }
  void setNodeInfo(Network net) {
    nodeNum = net.nodeNum ;
    sinkIndex = net.sinkIndex ;

    nodeIndices = new int[nodeNum] ;
    for (int i = 0 ; i < nodeNum ; i++) {
      nodeIndices[i] = i ;
    }
    if (sinkIndex != 0) {
      nodeIndices[sinkIndex] = 0 ;
      nodeIndices[0] = sinkIndex ;
    }
    free = new boolean[nodeNum] ;
    for (int i = 0 ; i < nodeNum ; i++) {
      free[i] = true ;
    }

    distances = new int[nodeNum] ;
    for (int i = 0 ; i < nodeNum ; i++) {
      distances[i] = Integer.MAX_VALUE / 2 ;
    }
    distances[net.sourceIndex] = 0 ;
  }
  void setEdgeInfo(Network net) {
    edgeNum = net.edges.length ;
    edgesBit = new long[edgeNum] ;
    long bit = 1 ;
    for (int i = 0 ; i < edgeNum ; i++) {
      edgesBit[i] = bit ;
      bit *= 2 ;
    }

    outGoing = new int[nodeNum][nodeNum][] ;
    inComing = new int[nodeNum][nodeNum][] ;
    outGoingNum = new int[nodeNum] ;
    inComingNum = new int[nodeNum] ;

    for (int i = 0 ; i < edgeNum ; i++) {
      int[] edge = net.edges[i] ;
      int tail = edge[TAIL] ;
      int head = edge[HEAD] ;
      outGoing[tail][outGoingNum[tail]] = edge ;
      outGoingNum[tail]++ ;
      inComing[head][inComingNum[head]] = edge ;
      inComingNum[head]++ ;
    }
  }
  void sortNodes() {
    if (sinkIndex != 0) {
      nodeIndices[sinkIndex] = 0 ;
      nodeIndices[0] = sinkIndex ;
    }
    int pos = 1 ;
    for (int i = 1 ; i < nodeNum ; i++) {
      for (int j = 0 ; j < outGoingNum[i] ; j++) {
        if (outGoing[i][j][HEAD] == sinkIndex) {
          int temp = nodeIndices[pos] ;
          nodeIndices[pos] = i ;
          nodeIndices[i] = temp ;
          pos++ ;
          break ;
        }
      }
    }
  }
  void reset() {
    for (int i = 0 ; i < nodeNum ; i++) {
      nodeIndices[i] = i ;
    }
  }
  int popNextNode() {
    int minPos = 0 ;
    for (int i = 1 ; i < nodeNum ; i++) {
      if (distances[nodeIndices[minPos]] > distances[nodeIndices[i]])
      minPos = i ;
    }
    nodeNum-- ;
    int u = nodeIndices[minPos] ;
    nodeIndices[minPos] = nodeIndices[nodeNum] ;
    nodeIndices[nodeNum] = u ;

    free[u] = false ;
    return u ;
  }
  void restoreNode(int nodeIndex) {
    nodeNum++ ;
    free[nodeIndex] = true ;
  }
  SolutionSet paretoBBSearch() {
    int start = millis() ;
    ps = new SolutionSet() ;
    sortNodes() ;
    branchAndBound(0, 0, null) ;
    int time = millis() - start ;
    allTime += time ;
    println("time : " + time + "\n") ;
    reset() ;
    return ps ;
  }
  void branchAndBound(long strategy, int cost, Solution cs) {
    int u = popNextNode() ;
    if (u == sinkIndex) {
      ps.insert_sort(strategy, cost, distances[sinkIndex]) ;
      solutionCount++ ;
    }
    else {
      branchAndBound(strategy, cost, cs, u, 0) ;
    }
    restoreNode(u) ;
  }
  void branchAndBound(long strategy, int cost, Solution cs, int nodeIndex, int k) {
    if (outGoingNum[nodeIndex] == k) {
      branchAndBound(strategy, cost, cs) ;
    }
    else {
      int[] e = outGoing[nodeIndex][k] ;
      k++ ;
      int ud = distances[nodeIndex] ;
      int dist = ud + e[ALPHA] ;

      int head = e[HEAD] ;
      int hd = distances[head] ;

      if (useful(head, dist, hd)) {
        if (head != sinkIndex || cs == null || cs.dominate(cost, dist) <= 0) {
          distances[head] = dist ;
          branchAndBound(strategy, cost, cs, nodeIndex, k) ;
        }
        distances[head] = min(hd, ud + e[BETA]) ;
        cost += e[COST] ;
        cs = ps.closestSolution(cs, cost) ;
        if (cs == null || cs.dominate(cost, distances[sinkIndex]) <= 0) {
          branchAndBound((strategy | edgesBit[e[INDEX]]), cost, cs, nodeIndex, k) ;
        }
        distances[head] = hd ;
      }
      else branchAndBound(strategy, cost, cs, nodeIndex, k) ;
    }
  }
  boolean useful(int head, int dist, int hd) {
    if (dist >= hd) return false ;
    for (int i = 0 ; i < inComingNum[head] ; i++) {
      int[] e = inComing[head][i] ;
      if (free[e[TAIL]] && distances[e[TAIL]] + e[BETA] <= dist) return false ;
    }
    return true ;
  }
  String toString() {
    String stg = "d:\t" + join(nf(distances, 0), ", ") + "\nn:\t";
    for (int i = 0 ; i < nodeIndices.length ; i++) {
      if (i == nodeNum) stg += "   |   " ;
      stg += nodeIndices[i] + ", " ;
    }
    stg += "\n" ;
    return stg ;
  }
}
