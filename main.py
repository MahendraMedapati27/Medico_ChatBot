from flask import Flask,request,jsonify
import db_helper
import generic_helper

inprogress_orders = {}
app = Flask(__name__)

@app.route('/', methods=['GET','POST'])
def handle_request():
    # Retrieve the json data from the request
    payload = request.json
    
    # Extract the neccesary information from the payload
    # Based on the structure of the webhookrequest from dialogflow
    intent = payload['queryResult']['intent']['displayName']
    parameters = payload['queryResult']['parameters']
    output_contexts = payload['queryResult']['outputContexts']
    
    session_id = generic_helper.extract_session_id(output_contexts[0]['name'])
    
    intent_handler_dict = {
        'order.add-context:ongoing-order': add_to_order,
        'order.remove-context:ongoing-order': remove_from_order,
        'order.complete-context: ongoing-order': complete_order,
        'track order - context: ongoing-tracking': track_order
    }
    
    return intent_handler_dict[intent](parameters,session_id)

def remove_from_order(parameters: dict, session_id: str):
    if session_id not in inprogress_orders:
        return jsonify({"fulfillmentText": "I am having trouble finding your order. Sorry! Can you Please place a new order"})
    
    current_order = inprogress_orders[session_id]
    print(current_order)
    # Ensure that the medicine names are provided as a string
    medicine_names_string = parameters.get('Medicine_Name', '')
    quantity = (parameters.get('Quantity', ''))
    print(quantity)
    print(medicine_names_string)
    # Split the medicine names string into individual medicine names
    medicine_list = [item for item in medicine_names_string]
    quantity_list = [str(item) for item in quantity]
    print(medicine_list)
    print(quantity_list)
    removed_items = []
    no_such_items = []

    # Iterate over each medicine name in the list
    for medicine, quantity in zip(medicine_list, quantity_list):
        # Check if the medicine name exists in the current order
        if medicine in current_order:
            # Check if the requested quantity is less than or equal to the quantity in the current order
            if str(current_order[medicine]) >= quantity:
                current_order[medicine] -= float(quantity)  # Reduce the quantity of the medicine
                removed_items.append(f"{quantity} {medicine}")
                # If the quantity becomes zero, remove the medicine from the order
                if current_order[medicine] == 0:
                    del current_order[medicine]
            else:
                # If the requested quantity is greater than the quantity in the current order, add to no_such_items
                no_such_items.append(f"{quantity} {medicine}")
        else:
            no_such_items.append(f"{quantity} {medicine}")

    fulfillment_text = ""

    if removed_items:
        fulfillment_text += f'Removed {", ".join(removed_items)} from your order. '

    if no_such_items:
        fulfillment_text += f'Your current order does not have {", ".join(no_such_items)}. '

    # If the order is empty after removal
    if not current_order:
        fulfillment_text += "Your order is empty"
    else:
        # Convert the remaining order items into a string
        order_items = [f"{quantity} {medicine}" for medicine, quantity in current_order.items()]
        order_str = ", ".join(order_items)
        fulfillment_text += f"Here is what is left in your order: {(order_str)}. Anything else you want to add or remove from your order."

    return jsonify({"fulfillmentText": fulfillment_text})
    
def complete_order(parameters: dict, session_id: str):
    if session_id not in inprogress_orders:
        fulfillment_text = 'I am having a trouble finding your order. Sorry! Can you please place a new order'
    else:
        order = inprogress_orders[session_id]
        order_id = save_to_db(order)
        
        if order_id == -1:
            fulfillment_text = "Sorry, I couldnt process your order due to backend error. "\
                                "Please place a new order again"
        else:
            order_total = db_helper.get_total_order_price(order_id)
            fulfillment_text = f"Awesome. We have placed your order. "\
                               f"Here is your order_id is {order_id} "\
                               f"Your order total is {int(order_total)} Rupees which you can pay at the time of delivery!"
                               
        del inprogress_orders[session_id]
    return jsonify({"fulfillmentText": fulfillment_text})
                
        
def save_to_db(order: dict):
    next_order_id = db_helper.get_next_order_id()
    for medicine, quantity in order.items():
        rcode=db_helper.insert_order_item(
            medicine,
            quantity,
            next_order_id
        )
        if rcode == -1:
            return -1
        
    db_helper.insert_order_tracking(next_order_id, "in progress")
        
    return next_order_id

def add_to_order(parameters: dict, session_id: str):
    valid_medicines = ['ibuprofen', 'paracetamol', 'amoxicillin', 'loratadine', 'omeprazole', 'simvastatin', 'metformin', 'salbutamol']  # Example list of valid medicine names
    medicine_list = parameters.get('Medicine_Name', [])  
    quantities = parameters.get("Quantity", [])          
    
    if len(medicine_list) != len(quantities):
        fulfillment_text ="Sorry, I cannot understand what you are saying. Please recheck the text you have entered and specify the quantity and name of medicines you need"
    else:
        new_food_dict = {}
        for medicine, quantity in zip(medicine_list, quantities):
            if medicine.lower() in valid_medicines:
                if session_id in inprogress_orders:
                    current_food_dict = inprogress_orders[session_id]
                    if medicine in current_food_dict:
                        current_food_dict[medicine] += quantity  # Increment the quantity if medicine exists
                    else:
                        current_food_dict[medicine] = quantity   # Add new medicine to the order
                    inprogress_orders[session_id] = current_food_dict
                else:
                    new_food_dict[medicine] = quantity
                    inprogress_orders[session_id] = new_food_dict
            else:
                return jsonify({
    "fulfillmentText": f"{medicine} is not a medicine that is available in our list. Please select from the following medicines:\n"
                       f"1) Paracetamol\n"
                       f"2) Ibuprofen\n"
                       f"3) Amoxicillin\n"
                       f"4) Loratadine\n"
                       f"5) Omeprazole\n"
                       f"6) Simvastatin\n"
                       f"7) Metformin\n"
                       f"8) Salbutamol."
                        })

        
        order_str = generic_helper.get_str_from_food_dict(inprogress_orders[session_id])
        fulfillment_text = f"So far you have {order_str}. Do you need anything else."
        
    return jsonify({"fulfillmentText": fulfillment_text})


    
def track_order(parameters: dict, session_id: str):
    order_id = parameters['Order_Id']
    order_status=db_helper.get_order_status(order_id)
    if order_status:
        fulfillment_text = f"The order status for order id {int(order_id)} is {order_status}"
    else:
        fulfillment_text = f"No order found with order id: {int(order_id)}"
        
    return jsonify({"fulfillmentText": fulfillment_text})
if __name__ == '__main__':
    app.run(debug=True, port = 5000)

