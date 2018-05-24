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

package com.ganymede.graph;

import graph.I_Graph.Edge;
import haxe.extern.EitherType;

//typedef Edge<E> = {
	//var weight: Float;
	//var data: E;
//};
private typedef EdgeList<E> = List<Edge<E>>;
private typedef EdgeMap<V,E> = Map<V, Edge<E>>;
private typedef EdgeMapList<V,E> = Map<V, EdgeList<E>>;

typedef AdjancencyMap<V,E> = Map<V, EdgeMap<V,E>>;
typedef AdjancencyList<V,E> = Map<V, EdgeMapList<V,E>>;

/**
 * Generic Graph
 * @author Drew Reese
 */
@:generic
@:remove
class Graph<V,E> implements I_Graph<V,E> {
	
	//private var _graph:AdjancencyMap<V,E>;
	private var _graph:EitherType<AdjancencyMap<V,E>,AdjancencyList<V,E>>;
	
	private var _directed:Bool;
	private var _multiEdge:Bool;
	private var _selfEdge:Bool;
	private var _acyclic:Bool;
	private var _built:Bool;
	
	public function new() {
		//this._graph = new AdjancencyList<V,E>();
		this._directed = false;
		this._multiEdge = false;
		this._selfEdge = false;
		this._acyclic = false;
		this._built = false;
	}
	
	public function directed(directed:Bool):Graph<V,E> {
		if (!this._built) this._directed = directed;
		return this;
	}
	
	public function allowMultiEdges(multiEdge:Bool):Graph<V,E> {
		if (!this._built) this._multiEdge = multiEdge;
		return this;
	}
	
	public function allowSelfEdges(selfEdge:Bool):Graph<V,E> {
		if (!this._built) this._selfEdge = selfEdge;
		return this;
	}
	
	public function allowCycles(cycles:Bool):Graph<V,E> {
		if (!this._built) this._acyclic = cycles;
		return this;
	}
	
	public function build():Graph<V,E> {
		if (!this._built) {
            if (_multiEdge) {
                this._graph = new AdjancencyMap<V,E>();
            } else {
			    this._graph = new AdjancencyList<V,E>();
            }
			this._built = true;
			trace(this);
		}
		return this;
	}
	
	private function checkBuilt() {
		if (!this._built) throw "Graph not built.";
	}
	
	public function add(vertex:V):Bool {
		checkBuilt();
		if (contains(vertex)) return false;
		
        if (_multiEdge) {
            (cast(_graph)).set(vertex, new EdgeMapList<V,E>());
        } else {
		    (cast(_graph)).set(vertex, new EdgeMap<V,E>());
        }
		return true;
	}
	
	public function remove(vertex:V):Bool {
        checkBuilt();
		if (!contains(vertex)) return false;
		
		for (v in getVertices(vertex)) {
			unconnect(vertex, v);
		}
		
		//return _graph.remove(vertex);
		return (cast(_graph)).remove(vertex);
        //if (_multiEdge) {
            //return (cast(_graph)).remove(vertex);
        //} else {
		    //return (cast(_graph)).remove(vertex);
        //}
	}
	
	public function connect(v1:V, v2:V, ?weight:Float = 1, ?data:E = null):Bool {
		checkBuilt();
        if ((!_selfEdge && v1 == v2) || (!_multiEdge && isConnected(v1, v2))) return false;
		
		var edge:Edge<E> = {data: data, weight: weight};
		//edge.data = data;
		//edge.weight = weight;
		
        // Step 1: add directed edge: v1 -> v2
        if (_multiEdge) {
            var eml:EdgeMapList<V,E> = (cast(_graph)).get(v1);
            var el:EdgeList<E> = eml.get(v2);
            el.push(edge);
            eml.set(v2, el);
            (cast(_graph)).set(v1, eml);
        } else {
            var em:EdgeMap<V,E> = (cast(_graph)).get(v1);
            em.set(v2, edge);
            (cast(_graph)).set(v1, em);
        }
		
        // Step 2: if undirected, add opposite edge: v1 <- v2
        if (!_directed) {
            if (_multiEdge) {
                var eml:EdgeMapList<V,E> = (cast(_graph)).get(v2);
                var el:EdgeList<E> = eml.get(v1);
                el.push(edge);
                eml.set(v1, el);
                (cast(_graph)).set(v2, eml);
            } else {
                var em:EdgeMap<V,E> = (cast(_graph)).get(v2);
                em.set(v1, edge);
                (cast(_graph)).set(v2, em);
            }
        }
		
		return true;
	}
	
	public function unconnect(v1:V, v2:V):EdgeList<E> {
		checkBuilt();
        if (!isConnected(v1, v2)) return null;
		
        var edges:EdgeList<E> = new EdgeList<E>();
        
        // Step 1: remove directed edge: v1 -> v2
        if (_multiEdge) {
            var eml:EdgeMapList<V,E> = (cast(_graph)).get(v1);
            var el:EdgeList<E> = eml.get(v2);
            for (e in el) {
                edges.push(e);
            }
            eml.remove(v2);
            (cast(_graph)).set(v1, eml);
        } else {
            var em:EdgeMap<V,E> = (cast(_graph)).get(v1);
            edges.push(em.get(v2));
            em.remove(v2);
            (cast(_graph)).set(v1, em);
        }
		
        // Step 2: if undirected, remove opposite edge: v1 <- v2
        if (!_directed) {
            (cast(_graph)).get(v2).remove(v1);
            //if (_multiEdge) {
                //var eml:EdgeMapList<V,E> = (cast(_graph)).get(v2);
                //em.remove(v1);
                //(cast(_graph)).set(v2, eml);
            //} else {
                //var em:EdgeMap<V,E> = (cast(_graph)).get(v2);
                //em.remove(v1);
                //(cast(_graph)).set(v2, em);
            //}
        }
        
		//var vm1:EdgeMap<V,E> = _graph.get(v1);
		//var edge:Edge<E> = vm1.get(v1);
		//vm1.remove(v2);
		//_graph.set(v1, vm1);
		//
		//var vm2:EdgeMap<V,E> = _graph.get(v2);
		//vm2.remove(v1);
		//_graph.set(v2, vm2);
		
		return edges;
	}
	
	public function contains(v:V):Bool {
		checkBuilt();
        return v == null ? false : (cast(_graph)).exists(v);
	}
	
	public function isConnected(v1:V, v2:V):Bool {
		checkBuilt();
        return contains(v1) && contains(v2) && (cast(_graph)).get(v1).exists(v2);
	}
	
	public function getVertices(?vertex:V = null):Iterator<V> {
		checkBuilt();
        return contains(vertex) ? (cast(_graph)).get(vertex).keys() : (cast(_graph)).keys();
	}
	
	public function getEdges(vertex:V):Iterator<Edge<E>> {
		checkBuilt();
        return contains(vertex) ? (cast(_graph)).get(vertex).iterator() : null;
	}
	
	public function getEdge(v1:V, v2:V):EdgeList<E> {
		checkBuilt();
        //return isConnected(v1,v2) ? _graph.get(v1).get(v2) : null;
		//return isConnected(v1,v2) ? _graph[v1][v2] : null;
        
        var edges:EdgeList<E> = new EdgeList<E>();
        
        if (_multiEdge) {
            var eml:EdgeMapList<V,E> = (cast(_graph)).get(v1);
            var el:EdgeList<E> = eml.get(v2);
            for (e in el) {
                edges.push(e);
            }
        } else {
            var em:EdgeMap<V,E> = (cast(_graph)).get(v1);
            edges.push(em.get(v2));
        }
        
        return edges;
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

	public function findPath(source:V, target:V):Void {
		dijkstras(source, target);
	}
	
	//public function findPath(source:V, destination:V, ?compareFunction):Void {
	public function dijkstras(source:V, ?destination:V = null):Map<V,V> {
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
			
			if (minVertex == destination) {
				return prev;
			} // found target, bail out
			
			for (vertex in getVertices(minVertex)) {
				if (toVisit.indexOf(vertex) == -1) continue;
				
				var alt = dist[minVertex] + getEdge(minVertex, vertex).first().weight;
				if (alt < dist[vertex]) {
					dist[vertex] = alt;
					prev[vertex] = minVertex;
				}
			}
		}
		
		// TODO: return path object??
		return prev;
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
	
	/*
1  S ← empty sequence
2  u ← target
3  while prev[u] is defined:                  // Construct the shortest path with a stack S
4      insert u at the beginning of S         // Push the vertex onto the stack
5      u ← prev[u]                            // Traverse from target to source
6  insert u at the beginning of S             // Push the source onto the stack
	 */
	private function getPath(prev:Map<V,V>, source:V, target:V):Array<V> {
		var S:Array<V> = new Array<V>();
		var u:V = source;
		
		while (prev[u] != null) {
			S.unshift(u);
			u = prev[u];
		}
		S.unshift(u);
		
		return S;
	}
	
}
