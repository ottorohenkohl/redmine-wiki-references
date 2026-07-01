# Wiki References

Ein Redmine-Plugin, das am Ende jeder Ticket-Seite die Wiki-Seiten anzeigt, die das Ticket über einen `#<id>`-Link referenzieren.
Die Referenzen werden in einer gepflegten Index-Tabelle materialisiert, die bei jedem Speichern von Wiki-Inhalt aktualisiert wird — die Anzeige kostet damit nur einen indizierten Lookup, unabhängig von der Größe des Wikis.

## Features

- Am Ende jeder Ticket-Seite:
  - Liste der Wiki-Seiten, die das Ticket via `#123` referenzieren (Seitentitel + Projekt)
  - projektübergreifende Referenzen werden korrekt aufgelöst
- Automatische Synchronisierung des Index:
  - `after_save` auf `WikiContent`: Referenzen der Seite neu berechnen (Anlegen/Bearbeiten)
  - `after_destroy` auf `WikiContent`: Referenzen der Seite entfernen (Seite gelöscht)
- Backfill bestehender Wiki-Inhalte bei der Installation (in der Migration) plus Rake-Task zum manuellen Neuaufbau
- Berechtigungsfilterung: nur für den Betrachter sichtbare Wiki-Seiten (`WikiPage#visible?`, Recht `:view_wiki_pages`)

## Kompatibilität

Das Plugin wurde für Redmine (Version >= 6.0.0) entwickelt. Es verwendet Migrationen mit `ActiveRecord::Migration[6.1]` (kompatibel von Rails 6.1 bis 7.x/8.x), daher achte auf die Rails-/Redmine-Version deiner Installation. View-Hook und Model-Patch sind Zeitwerk-sicher und überstehen Code-Reloads im Development-Modus, ohne sich mehrfach zu registrieren.

## Installation

1. In dein Redmine-Verzeichnis wechseln.
2. Das Plugin-Verzeichnis nach `plugins/redmine_wiki_references/` kopieren und nach Bedarf umbenennen.
3. Migration mit `rake redmine:plugins:migrate RAILS_ENV=production` ausführen (legt die Tabelle an und befüllt sie aus dem vorhandenen Wiki-Inhalt).
4. Redmine neu starten.

## Nutzung

- Öffne ein Ticket. Wird es von Wiki-Seiten via `#<id>` referenziert, erscheint unten der Abschnitt „Referenziert von Wikiseiten“ mit Links zu diesen Seiten.
- Der Index bleibt automatisch aktuell:
  - Beim Speichern einer Wiki-Seite werden ihre Referenzen neu berechnet.
  - Beim Löschen einer Wiki-Seite werden ihre Referenzen entfernt.
- Verhalten bei noch nicht existierenden Tickets:
  - Es wird jede `#<id>`-Referenz gespeichert, auch auf (noch) nicht existierende Tickets. Da Redmine Ticket-IDs nie wiederverwendet, ist das harmlos: Eine Seite, die `#999` erwähnt, taucht automatisch korrekt auf, sobald Ticket 999 angelegt wird — ohne Reindex.
- Einschränkung:
  - Ein `#<id>` innerhalb eines Code-Blocks oder einer literalen URL wird mitindiziert, obwohl Redmine es nicht als Link darstellen würde. Perfekte Treue bräuchte den vollständigen Wiki-Formatter pro Seite und wäre für eine Backlink-Liste unverhältnismäßig.

## Datenbank

- Model: `WikiPageIssueReference` (Tabelle `wiki_page_issue_references`)
  - Spalten: `wiki_page_id`, `issue_id` (Integer)
  - Indizes: eindeutiger Index auf `(wiki_page_id, issue_id)`, zusätzlicher Index auf `issue_id`
- Migration: `db/migrate/001_create_wiki_page_issue_references.rb`
  - legt die Tabelle an und führt das Backfill über `RedmineWikiReferences::Indexer.reindex_all` aus
