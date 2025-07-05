import PropTypes from 'prop-types';
import React from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

// material-ui
import Button from '@mui/material/Button';
import Checkbox from '@mui/material/Checkbox';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormHelperText from '@mui/material/FormHelperText';
import Grid from '@mui/material/Grid2';
import Link from '@mui/material/Link';
import InputAdornment from '@mui/material/InputAdornment';
import InputLabel from '@mui/material/InputLabel';
import OutlinedInput from '@mui/material/OutlinedInput';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import Snackbar from '@mui/material/Snackbar';
import MuiAlert from '@mui/material/Alert';

// third-party
import * as Yup from 'yup';
import { Formik } from 'formik';

// project imports
import IconButton from 'components/@extended/IconButton';
import AnimateButton from 'components/@extended/AnimateButton';

// assets
import EyeOutlined from '@ant-design/icons/EyeOutlined';
import EyeInvisibleOutlined from '@ant-design/icons/EyeInvisibleOutlined';

// ============================|| JWT - LOGIN ||============================ //

export default function AuthLogin({ isDemo = false }) {
  const [checked, setChecked] = React.useState(false);

  const [showPassword, setShowPassword] = React.useState(false);

  const [loginError, setLoginError] = React.useState('');
  const navigate = useNavigate();

  const [openSnackbar, setOpenSnackbar] = React.useState(false);

  const handleClickShowPassword = () => {
    setShowPassword(!showPassword);
  };

  const handleMouseDownPassword = (event) => {
    event.preventDefault();
  };

  // Hàm xử lý đăng nhập
  const handleLogin = async (values, { setSubmitting }) => {
    setLoginError('');
    try {
      const res = await fetch('https://corehr.igroup.com.vn/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: values.email,
          password: values.password
        })
      });
      const data = await res.json();
      if (res.ok && data.token) {
        localStorage.setItem('token', data.token);
        localStorage.setItem('user', JSON.stringify(data.manager));
        setOpenSnackbar(true); // Hiện thông báo
        setTimeout(() => {
          navigate('/');
        }, 1200); // Chuyển trang sau 1.2 giây
      } else {
        setLoginError(data.error || 'Đăng nhập thất bại!');
      }
    } catch (err) {
      setLoginError('Lỗi kết nối server!');
    }
    setSubmitting(false);
  };

  return (
    <>
      <Formik
        initialValues={{
          email: '',
          password: '',
          submit: null
        }}
        validationSchema={Yup.object().shape({
          email: Yup.string().max(255).required('Vui lòng nhập thông tin tài khoản!'),
          password: Yup.string()
            .required('Vui lòng nhập mật khẩu!')
            .test(
              'Mật khẩu không được có khoảng trắng đầu cuối',
              'Mật khẩu không thể bắt đầu hoặc kết thúc bằng khoảng trắng',
              (value) => value === value.trim()
            )
            .max(10, 'Mật khẩu không được quá 10 ký tự!')
        })}
        onSubmit={handleLogin}
      >
        {({ errors, handleBlur, handleChange, handleSubmit, isSubmitting, touched, values }) => (
          <form noValidate onSubmit={handleSubmit}>
            <Grid container spacing={3}>
              <Grid size={12}>
                <Stack sx={{ gap: 1 }}>
                  <InputLabel htmlFor="email-login">Tên tài khoản</InputLabel>
                  <OutlinedInput
                    id="email-login"
                    type="text"
                    value={values.email}
                    name="email"
                    onBlur={handleBlur}
                    onChange={handleChange}
                    placeholder="Nhập thông tin tài khoản"
                    fullWidth
                    error={Boolean(touched.email && errors.email)}
                  />
                </Stack>
                {touched.email && errors.email && (
                  <FormHelperText error id="standard-weight-helper-text-email-login">
                    {errors.email}
                  </FormHelperText>
                )}
              </Grid>
              <Grid size={12}>
                <Stack sx={{ gap: 1 }}>
                  <InputLabel htmlFor="password-login">Mật khẩu</InputLabel>
                  <OutlinedInput
                    fullWidth
                    error={Boolean(touched.password && errors.password)}
                    id="-password-login"
                    type={showPassword ? 'text' : 'password'}
                    value={values.password}
                    name="password"
                    onBlur={handleBlur}
                    onChange={handleChange}
                    endAdornment={
                      <InputAdornment position="end">
                        <IconButton
                          aria-label="toggle password visibility"
                          onClick={handleClickShowPassword}
                          onMouseDown={handleMouseDownPassword}
                          edge="end"
                          color="secondary"
                        >
                          {showPassword ? <EyeOutlined /> : <EyeInvisibleOutlined />}
                        </IconButton>
                      </InputAdornment>
                    }
                    placeholder="Nhập mật khẩu"
                  />
                </Stack>
                {touched.password && errors.password && (
                  <FormHelperText error id="standard-weight-helper-text-password-login">
                    {errors.password}
                  </FormHelperText>
                )}
              </Grid>
              <Grid sx={{ mt: -1 }} size={12}>
                <Stack direction="row" sx={{ gap: 2, alignItems: 'baseline', justifyContent: 'space-between' }}>
                  <FormControlLabel
                    control={
                      <Checkbox
                        checked={checked}
                        onChange={(event) => setChecked(event.target.checked)}
                        name="checked"
                        color="primary"
                        size="small"
                      />
                    }
                    label={<Typography variant="h6">Nhớ mật khẩu</Typography>}
                  />
                  <Link variant="h6" component={RouterLink} to="#" color="text.primary">
                    Quên mật khẩu?
                  </Link>
                </Stack>
              </Grid>
              <Grid size={12}>
                <AnimateButton>
                  <Button fullWidth size="large" variant="contained" color="primary" type="submit" disabled={isSubmitting}>
                    Đăng nhập
                  </Button>
                </AnimateButton>
                {loginError && (
                  <FormHelperText error sx={{ mt: 1 }}>
                    {loginError}
                  </FormHelperText>
                )}
              </Grid>
            </Grid>
          </form>
        )}
      </Formik>
      <Snackbar
        open={openSnackbar}
        autoHideDuration={1000}
        onClose={() => setOpenSnackbar(false)}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <MuiAlert elevation={6} variant="filled" severity="success">
          Đăng nhập thành công!
        </MuiAlert>
      </Snackbar>
    </>
  );
}

AuthLogin.propTypes = { isDemo: PropTypes.bool };
