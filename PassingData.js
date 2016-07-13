'use strict';

var React = require('react');
import { StyleSheet, Text, View, TouchableHighlight, NativeModules, NavigatorIOS } from 'react-native';

var RNBridge = require('react-native-controller-bridge');

var SimpleList = require('./SimpleList');

class PassingData extends React.Component {
  constructor(props) {

    super(props);
    this.state = {subscription: false};
    this.controller = RNBridge.Controller(props.rn_controllerId);
  }
    _handleButton() {
      this.controller.dismiss(true, function() {
        console.log("hello");
      });
    }

    _next() {
      self.controller.push({
        title: 'hello',
        component: 'ModalWithNavigator',
        style: {
          hideNavigationBar: true,
          hideNavigationBarAnimated: false,
        }
      }, true);
    }

    _handleRowPress() {
        this.refs.navigator.push({
            title: 'Simple View',
            component: SimpleView,
        });
    }

    render() {
        return (
            <NavigatorIOS
                ref="navigator"
                style={styles.container}
                initialRoute={{
                    title: 'PassingData',
                    component: SimpleList,
                    passProps: {
                        data: this.props.data,
                        rowPressed: this._handleRowPress.bind(this)
                    },
                    leftButtonTitle: 'Close',
                    onLeftButtonPress: this._handleButton.bind(this),
                }}
            />
        );
    }
}

var styles = StyleSheet.create({
    container: {
        flex: 1,
    }
});

PassingData.propTypes = {
    // This prop is passed down in `initialProperties` from Obj-C.
    data: React.PropTypes.array.isRequired,
};

module.exports = PassingData;
