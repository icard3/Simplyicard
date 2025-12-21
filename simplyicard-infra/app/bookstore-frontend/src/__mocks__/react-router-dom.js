// Mock for react-router-dom
const mockBrowserRouter = ({ children }) => <div>{children}</div>;
const mockRoutes = ({ children }) => <div>{children}</div>;
const mockRoute = ({ children }) => <div>{children}</div>;
const mockUseNavigate = () => jest.fn();
const mockLink = ({ children, to }) => <a href={to}>{children}</a>;
const mockUseParams = () => ({});
const mockUseLocation = () => ({ pathname: '/' });
const mockNavigate = ({ to }) => <div>Redirecting to {to}</div>;
const mockOutlet = () => <div>Outlet</div>;

module.exports = {
  BrowserRouter: mockBrowserRouter,
  Routes: mockRoutes,
  Route: mockRoute,
  useNavigate: mockUseNavigate,
  Link: mockLink,
  useParams: mockUseParams,
  useLocation: mockUseLocation,
  Navigate: mockNavigate,
  Outlet: mockOutlet
};