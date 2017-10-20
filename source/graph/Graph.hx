/**
 *  Copyright (C) 2017  Andrew Reese
 * 
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package graph;

typedef Edge<E> = {
	var weight: Float;
	var data: E;
};
private typedef EdgeMap<V,E> = Map<V, Edge<E>>;
typedef AdjancencyList<V,E> = Map<V, EdgeMap<V,E>>;

/**
 * Generic Graph
 * @author Drew Reese
 */
@:generic
@:remove
class Graph<V,E> {
	
	private var _graph:AdjancencyList<V,E>;
	private var _directed:Bool;
	private var _acyclic:Bool;

	public function new() {
		this._graph = new AdjancencyList<V,E>();
	}
	
	public function add(vertex:V):Bool {
		if (contains(vertex)) return false;
		
		_graph.set(vertex, new EdgeMap<V,E>());
		return true;
	}
	
	public function remove(vertex:V):Bool {
		if (!contains(vertex)) return false;
		
		for (v in getVertices(vertex)) {
			unconnect(vertex, v);
		}
		
		return _graph.remove(vertex);
	}
	
	public function connect(v1:V, v2:V, ?data:E = null, ?weight:Float = 1):Bool {
		if (v1 == v2 || isConnected(v1, v2)) return false;
		
		var edge:Edge<E> = {data: data, weight: weight};
		//edge.data = data;
		//edge.weight = weight;
		
		var vm1:EdgeMap<V,E> = _graph.get(v1);
		vm1.set(v2, edge);
		_graph.set(v1, vm1);
		
		var vm2:EdgeMap<V,E> = _graph.get(v2);
		vm2.set(v1, edge);
		_graph.set(v2, vm2);
		
		return true;
	}
	
	public function unconnect(v1:V, v2:V):Edge<E> {
		if (!isConnected(v1, v2)) return null;
		
		var vm1:EdgeMap<V,E> = _graph.get(v1);
		var edge:Edge<E> = vm1.get(v1);
		vm1.remove(v2);
		_graph.set(v1, vm1);
		
		var vm2:EdgeMap<V,E> = _graph.get(v2);
		vm2.remove(v1);
		_graph.set(v2, vm2);
		
		return edge;
	}
	
	public function contains(v:V):Bool {
		return v == null ? false : this._graph.exists(v);
	}
	
	public function isConnected(v1:V, v2:V):Bool {
		return contains(v1) && contains(v2) && _graph.get(v1).exists(v2);
	}
	
	public function getVertices(?vertex:V = null):Iterator<V> {
		return contains(vertex) ? _graph.get(vertex).keys() : _graph.keys();
	}
	
	public function getEdges(vertex:V):Iterator<Edge<E>> {
		return contains(vertex) ? _graph.get(vertex).iterator() : null;
	}
	
	public function getEdge(v1:V, v2:V):Edge<E> {
		//return isConnected(v1,v2) ? _graph.get(v1).get(v2) : null;
		return isConnected(v1,v2) ? _graph[v1][v2] : null;
	}
	
	// 9/13/2017 7:26 AM
	// Graph traversals & path finding should probably reside here, 
	// or perhaps in a separate GraphUtil class (i.e. separate out
	// data structure & generic operations).  Path finding should
	// take as a parameter an edge compare function else it should
	// assume graph has edges of equal weight.
	
/*
 1	function Dijkstra(Graph, source):
 2
 3      create vertex set Q
 4
 5      for each vertex v in Graph:             // Initialization
 6          dist[v] ← INFINITY                  // Unknown distance from source to v
 7          prev[v] ← UNDEFINED                 // Previous node in optimal path from source
 8          add v to Q                          // All nodes initially in Q (unvisited nodes)
 9
10      dist[source] ← 0                        // Distance from source to source
11      
12      while Q is not empty:
13          u ← vertex in Q with min dist[u]    // Node with the least distance will be selected first
14          remove u from Q 

If we are only interested in a shortest path between 
vertices source and target, we can terminate the 
search after line 15 if u = target

15          
16          for each neighbor v of u:           // where v is still in Q.
17              alt ← dist[u] + length(u, v)
18              if alt < dist[v]:               // A shorter path to v has been found
19                  dist[v] ← alt 
20                  prev[v] ← u 
21
22      return dist[], prev[]

Now we can read the shortest path from source to target by reverse iteration

1  S ← empty sequence
2  u ← target
3  while prev[u] is defined:                  // Construct the shortest path with a stack S
4      insert u at the beginning of S         // Push the vertex onto the stack
5      u ← prev[u]                            // Traverse from target to source
6  insert u at the beginning of S             // Push the source onto the stack

*/
	
	//public function findPath(source:V, destination:V, ?compareFunction):Void {
	public function findPath(source:V, destination:V):Void {
		var dist:Map<V,Float> = new Map<V,Float>();
		var prev:Map<V,V> = new Map<V,V>();
		var toVisit:Array<V> = new Array<V>();
		
		for (v in this.getVertices()) {
			dist[v] = Math.POSITIVE_INFINITY;
			prev[v] = null;
			toVisit.push(v);
		}
		dist[source] = 0.0;
		
		while (toVisit.length > 0) {
			//var minVertex:V = minDist(dist, compareFunction);
			var minVertex:V = minDist(dist);
			toVisit.remove(minVertex);
			
			for (vertex in getVertices(minVertex)) {
				var alt = dist[minVertex] + getEdge(minVertex, vertex).weight;
				if (alt < dist[vertex]) {
					dist[vertex] = alt;
					prev[vertex] = minVertex;
				}
			}
		}
		
		// TODO: return path object??
	}
	
	//private function minDist(distMap:Map<V,Float>, compareFn:E->E->Int):V {
	private function minDist(distMap:Map<V,Float>):V {
		var minVertex:V = null;
		var minDist:Float = null;
		
		for (vertex in distMap.keys()) {
			var curDist:Float = distMap.get(vertex);
			
			if (minDist == null) {
				minDist = curDist;
				minVertex = vertex;
			} else {
				//if (compareFn(curDist, minDist) < 0) { // use compare here
				if (curDist < minDist) {
					minDist = curDist;
					minVertex = vertex;
				}
			}
		}
		
		return minVertex;
	}
	
}
