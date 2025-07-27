import * as fs from 'node:fs'
import * as path from 'node:path'
import * as url from 'node:url'

const dirname = path.dirname(url.pathToFileURL(import.meta.url))
