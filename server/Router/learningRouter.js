import express from 'express'
import { alphabetEngNext, alphabetEngPrev,alphabetGujaratiNext,alphabetGujaratiPrev,NumberNext,NumberPrev} from '../Ctrl/learnCtrl.js'

const router = express.Router()

router.get('/alphabetEng/', alphabetEngNext)
router.get('/alphabetEng/next', alphabetEngNext)
router.get('/alphabetEng/prev', alphabetEngPrev)
router.get('/alphabetGuj', alphabetGujaratiNext)
router.get('/alphabetGuj/next', alphabetGujaratiNext)
router.get('/alphabetGuj/prev', alphabetGujaratiPrev)
router.get('/Number', NumberNext)
router.get('/Number/next', NumberNext)
router.get('/Number/prev', NumberPrev)
// router.get('/alphabetGuj', alphabetGuj)

export default router