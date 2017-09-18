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

//typedef VertexMap<V,E> = Map<V,E>;
//typedef AdjancencyList<V,VertexMap> = Map<V, VertexMap>;

/**
 * Generic Graph
 * @author Drew Reese
 */
@:generic
@:remove
class Graph<V,E> {
	
	//private var _graph:AdjancencyList<V,VertexMap<V,E>>;
	private var _graph:Map<V,Map<V,E>>;
	private var _directed:Bool;
	private var _acyclic:Bool;

	public function new() {
		this._graph = new Map<V,Map<V,E>>();
	}
	
	public function add(vertex:V):Bool {
		if (contains(vertex)) return false;
		
		_graph.set(vertex, new Map<V,E>());
		return true;
	}
	
	public function remove(vertex:V):Bool {
		if (!contains(vertex)) return false;
		
		var vi:Iterator<V> = getVertices(vertex);
		
		while (vi.hasNext()) {
			unconnect(vertex, vi.next());
		}
		
		return _graph.remove(vertex);
	}
	
	public function connect(v1:V, v2:V, ?edgeData:E = null):Bool {
		if (v1 == v2 || isConnected(v1, v2)) return false;
		
		//_graph.get(v1).set(v2, edgeData);
		//_graph.get(v2).set(v1, edgeData);
		
		var vm1:Map<V,E> = _graph.get(v1);
		vm1.set(v2, edgeData);
		_graph.set(v1, vm1);
		
		var vm2:Map<V,E> = _graph.get(v2);
		vm2.set(v1, edgeData);
		_graph.set(v2, vm2);
		
		return true;
	}
	
	public function unconnect(v1:V, v2:V):E {
		if (!isConnected(v1, v2)) return null;
		
		var vm1:Map<V,E> = _graph.get(v1);
		var edgeData = vm1.get(v1);
		vm1.remove(v2);
		_graph.set(v1, vm1);
		
		var vm2:Map<V,E> = _graph.get(v2);
		vm2.remove(v1);
		_graph.set(v2, vm2);
		
		return edgeData;
	}
	
	public function contains(v:V):Bool {
		return v == null ? false : this._graph.exists(v);
	}
	
	public function isConnected(v1:V, v2:V):Bool {
		if (!(contains(v1) && contains(v2))) return false;
		return _graph.get(v1).exists(v2);
	}
	
	public function getVertices(?vertex:V = null):Iterator<V> {
		return vertex == null ? _graph.keys() : _graph.get(vertex).keys();
	}
	
	// 9/13/2017 7:26 AM
	// Graph traversals & path finding should probably reside here, 
	// or perhaps in a separate GraphUtil class (i.e. separate out
	// data structure & generic operations).  Path finding should
	// take as a parameter an edge compare function else it should
	// assume graph has edges of equal weight.
	
	public function findPath(v1:V, v2:V, ?compareFunction):Void {
		var res:Int = compareFunction(1, 2);
		trace('Compare result: ${res}');
	}
	
}