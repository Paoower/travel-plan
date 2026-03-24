// Neo4j Schema for Travel Management System
// Handles: Destination graphs, routes, connections, recommendations

// ============================================
// DESTINATION NODES
// ============================================
// Creates a Destination node with properties
CREATE CONSTRAINT destination_id IF NOT EXISTS FOR (d:Destination) REQUIRE d.id IS UNIQUE;
CREATE INDEX destination_name IF NOT EXISTS FOR (d:Destination) ON (d.name);
CREATE INDEX destination_country IF NOT EXISTS FOR (d:Destination) ON (d.country);

// Example:
// CREATE (d:Destination {
//   id: "uuid",
//   name: "Paris",
//   country: "France",
//   latitude: 48.8566,
//   longitude: 2.3522,
//   description: "City of Light",
//   population: 2161000,
//   timezone: "Europe/Paris"
// })

// ============================================
// TRAVEL NODES
// ============================================
CREATE CONSTRAINT travel_id IF NOT EXISTS FOR (t:Travel) REQUIRE t.id IS UNIQUE;
CREATE INDEX travel_title IF NOT EXISTS FOR (t:Travel) ON (t.title);

// ============================================
// CATEGORY NODES
// ============================================
CREATE CONSTRAINT category_name IF NOT EXISTS FOR (c:Category) REQUIRE c.name IS UNIQUE;

// Categories: "Beach", "Mountain", "Culture", "Food", "Adventure", "Relaxation"
// Example:
// CREATE (c:Category {name: "Beach", description: "Beach destinations"})

// ============================================
// RELATIONSHIPS
// ============================================

// 1. VISITED_BY - Travel to Destination (ordered)
// CREATE (t:Travel)-[:VISITED_BY {order: 1, days: 3}]->(d:Destination)

// 2. CONNECTED_TO - Destination to Destination (direct routes/proximity)
// CREATE (d1:Destination)-[:CONNECTED_TO {
//   distance_km: 215,
//   transport_types: ["FLIGHT", "TRAIN", "CAR"],
//   typical_duration_hours: 2.5
// }]->(d2:Destination)

// 3. CATEGORIZED_AS - Destination to Category (multiple categories per destination)
// CREATE (d:Destination)-[:CATEGORIZED_AS {confidence: 0.95}]->(c:Category)

// 4. SIMILAR_TO - Destination to Destination (recommendation engine)
// CREATE (d1:Destination)-[:SIMILAR_TO {similarity_score: 0.87}]->(d2:Destination)

// 5. SUITABLE_FOR - Category to Activity Type
// CREATE (c:Category)-[:SUITABLE_FOR {relevance: 0.92}]->(a:ActivityType)

// ============================================
// ACTIVITY TYPE NODES
// ============================================
CREATE CONSTRAINT activity_type_name IF NOT EXISTS FOR (a:ActivityType) REQUIRE a.name IS UNIQUE;

// Examples: "Hiking", "Scuba Diving", "Museum", "Restaurant", "Boat Tour", etc.

// ============================================
// SAMPLE CYPHER QUERIES FOR RECOMMENDATION ENGINE
// ============================================

-- Find all destinations connected to Paris:
-- MATCH (paris:Destination {name: "Paris"})-[:CONNECTED_TO]->(dest:Destination)
-- RETURN dest

-- Find destinations in the same category as Paris:
-- MATCH (paris:Destination {name: "Paris"})-[:CATEGORIZED_AS]->(cat:Category)
--       <-[:CATEGORIZED_AS]-(similar:Destination)
-- RETURN similar

-- Find similar destinations with similarity score:
-- MATCH (paris:Destination {name: "Paris"})-[sim:SIMILAR_TO]->(dest:Destination)
-- RETURN dest, sim.similarity_score ORDER BY sim.similarity_score DESC

-- Find recommended next destination in a travel itinerary:
-- MATCH (travel:Travel)-[:VISITED_BY {order: $lastOrder}]->(current:Destination)
--       -[:CONNECTED_TO]->(next:Destination)
-- WHERE next NOT IN (SELECT d FROM travel.destinations)
-- RETURN next ORDER BY current.distance_km LIMIT 5

-- Find all activity types suitable for a destination category:
-- MATCH (dest:Destination)-[:CATEGORIZED_AS]->(cat:Category)
--       -[:SUITABLE_FOR]->(activity:ActivityType)
-- WHERE dest.name = $destName
-- RETURN activity

-- Find shortest route between two destinations:
-- MATCH path = shortestPath((start:Destination)-[:CONNECTED_TO*]->(end:Destination))
-- WHERE start.name = $startName AND end.name = $endName
-- RETURN path

// ============================================
// INDEXES FOR PERFORMANCE
// ============================================
CREATE INDEX destination_created IF NOT EXISTS FOR (d:Destination) ON (d.created_at);
CREATE INDEX travel_status IF NOT EXISTS FOR (t:Travel) ON (t.status);
CREATE INDEX category_description IF NOT EXISTS FOR (c:Category) ON (c.description);
