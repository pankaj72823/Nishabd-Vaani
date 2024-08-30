import express from 'express'
import { alphabetEngNext, alphabetEngPrev,alphabetEng} from '../Ctrl/engCtrl.js'
import {alphabetGujaratiNext,alphabetGujaratiPrev,alphabetGujarati} from '../Ctrl/gujCtrl.js'
import { NumberNext,NumberPrev,numberSign} from '../Ctrl/numberCtrl.js'


const router = express.Router()

router.get('/alphabetEng/', alphabetEng)
router.get('/alphabetEng/next', alphabetEngNext)
router.get('/alphabetEng/prev', alphabetEngPrev)
router.get('/alphabetGuj', alphabetGujarati)
router.get('/alphabetGuj/next', alphabetGujaratiNext)
router.get('/alphabetGuj/prev', alphabetGujaratiPrev)
router.get('/Number', numberSign)
router.get('/Number/next', NumberNext)
router.get('/Number/prev', NumberPrev)
// router.get('/alphabetGuj', alphabetGuj)

export default router