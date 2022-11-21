const table = "notes";
const noteId = "ID";
const title = "Title";
const text = "Text";
const date = "Date";
const rememberDate = "RememberDate";
const favourite = "Favourite";
const position = "position";
const archived = "archived";
const list = "list";
const listTitle = "listTitle";
const itemsTable = "Items";
const itemId = "ID";
const itemText = "Text";
const itemDone = "Done";
const itemNoteID = "NoteID";

const createNotesTable = """CREATE TABLE IF NOT EXISTS "$table" (
	"$noteId"	INTEGER NOT NULL UNIQUE,
  "$position" INTEGER,
	"$title"	TEXT,
	"$text"	TEXT,
	"$date"	TEXT,
	"$rememberDate"	TEXT,
	"$favourite"	TEXT,
  "$archived" TEXT,
  "$list" TEXT,
  "$listTitle" TEXT,
	PRIMARY KEY("$noteId" AUTOINCREMENT)
)""";

const createListItemsTable = """CREATE TABLE IF NOT EXISTS "$itemsTable" (
	"$itemId"	INTEGER NOT NULL UNIQUE,
	"$itemText"	TEXT,
  "$itemDone" TEXT,
  "$itemNoteID" INTEGER,
	PRIMARY KEY("$itemId" AUTOINCREMENT)
)""";
