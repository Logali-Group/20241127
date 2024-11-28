const cds = require('@sap/cds');

module.exports = class LogaliGroup extends cds.ApplicationService {

    async init () {

        const {ProducstSet, Suppliers} = this.entities;
        const api = await cds.connect.to("API_BUSINESS_PARTNER");

        this.on('READ', Suppliers, async (req)=> {
            return await api.tx(req).send({
                query: req.query,
                headers: {
                    apikey: process.env.APIKEY
                }
            })
        })

        this.on('add', async (req)=>{
            const id = req.params[0].ID;
            const product = req.params[0].product;
            const result = await SELECT.one.from(ProducstSet).where({ID: id, product: product}).columns(`value`);
            const add = result.value + req.data.quantity;
            await UPDATE.entity(ProducstSet).set({value: add}).where({ID: id, product: product});
            await this.updateStock(req, ProducstSet, add);
        });


        return super.init();
    };

    async updateStock (req, entity, value) {

        const id = req.params[0].ID;
        const product = req.params[0].product;

        let stock_code = "",
            criticality = 0;

        // 0        --> NotInStock
        // 1-30     --> LowAvailability
        // 31-100   --> InStock

        if (value === 0) {
            stock_code = "NotInStock";
            criticality = 1;
        } else if (value > 0 && value <= 30) {
            stock_code = "LowAvailability";
            criticality = 2;
        } else if (value > 30) {
            stock_code = "InStock";
            criticality = 3;
        }

        await cds.tx(req).run(
            await UPDATE.entity(entity).set({stock_code: stock_code, criticality: criticality}).where({ID: id, product: product})
        ).then(()=>{
            req.notify("Registro exitoso");
        }).catch(()=>{
            req.error("Ocurrió un error durante el proceso");
        });
    }

}