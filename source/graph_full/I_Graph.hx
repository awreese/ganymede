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

/**
 * @author Drew Reese
 */
interface I_Graph<V,E> {
	private var _directed:Bool;
	private var _multiEdge:Bool;
	private var _selfEdge:Bool;
	private var _acyclic:Bool;
	
	public function add(vertex:V):Bool;
	public function remove(vertex:V):Bool;
	public function connect(v1:V, v2:V, ?weight:Float = 1, ?data:E = null):Bool;
	public function unconnect(v1:V, v2:V):List<Edge<E>>;
	public function contains(vertex:V):Bool;
	public function isConnected(v1:V, v2:V):Bool;
	public function getVertices(?vertex:V = null):Iterator<V>;
	public function getEdges(vertex:V):Iterator<Edge<E>>;
	public function getEdge(v1:V, v2:V):List<Edge<E>>;
}