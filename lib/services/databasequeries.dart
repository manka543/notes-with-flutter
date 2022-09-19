const createNotesTable = """CREATE TABLE IF NOT EXISTS "notes" (
	"ID"	INTEGER NOT NULL UNIQUE,
	"Title"	TEXT,
	"Text"	TEXT,
	"Date"	TEXT,
	"RememberDate"	TEXT,
	"Favourite"	TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT)
)""";

const table = "notes";
const noteid = "ID";
const title = "Title";
const text = "Text";
const date = "Date";
const rememberDate = "RememberDate";
const favourite = "Favourite";
