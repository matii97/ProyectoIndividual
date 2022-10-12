import { LightningElement, wire, api, track } from 'lwc';
import getunitwrapper from '@salesforce/apex/UnitService.getUnitWrapper';
import registerUserAnswer from '@salesforce/apex/UnitService.registerUserAnswer';



export default class Unitcontent extends LightningElement {
    @api recordId;

    unit;
    questionList;
    _wireResult;
    subscription = null;
    points;
    name;
    time;
    description;
    preguntas;
    Alert;

    @wire(MessageContext)
    messageContext;

    @wire(getunitwrapper, { unitId: '$recordId' })
    unitdata(result) {
        const { data, error } = result;
        this._wireResult = result;

        console.log();
        if (data) {
            this.unit = data.unit;
            this.name = this.unit.Name;
            this.points = this.unit.Points__c;
            this.time = this.unit.Time__c;
            this.description = this.unit.description__c;
            this.preguntas = data.questions;
        }

    }
    @track
    optionSelected = [];
    optionSelectedjson = {};
    answerSelected(event) {

        console.log(JSON.stringify(event.detail) + 'detail event');
        this.optionSelectedjson[event.detail.questionId] = event.detail.optionId;
        console.log('objeto' + JSON.stringify(this.optionSelectedjson));
        this.optionSelected = Object.values(this.optionSelectedjson);
        console.log('arraypadre' + this.optionSelected);
    }


    handleSubmit(event) {
        registerUserAnswer({
            unitId: this.recordId,
            jsonAnswer: JSON.stringify(this.optionSelectedjson)
        })

        .catch((error) => {
            console.log(error)
        })
    }

}